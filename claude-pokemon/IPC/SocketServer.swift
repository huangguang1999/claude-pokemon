import Foundation

/// Unix domain socket server listening on /tmp/claude-island.sock
final class SocketServer: Sendable {
    private let socketPath = "/tmp/claude-island.sock"
    private let sessionManager: SessionManager

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }

    private func reportError(_ message: String) {
        fputs("[SocketServer] \(message)\n", stderr)
    }

    func start() async {
        // Clean up stale socket
        unlink(socketPath)

        let serverFd = socket(AF_UNIX, SOCK_STREAM, 0)
        guard serverFd >= 0 else {
            reportError("Failed to create socket: \(errno)")
            return
        }

        var addr = sockaddr_un()
        addr.sun_family = sa_family_t(AF_UNIX)
        withUnsafeMutablePointer(to: &addr.sun_path) { ptr in
            socketPath.withCString { cstr in
                _ = memcpy(ptr, cstr, min(socketPath.utf8.count, 104))
            }
        }

        let bindResult = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockPtr in
                bind(serverFd, sockPtr, socklen_t(MemoryLayout<sockaddr_un>.size))
            }
        }

        guard bindResult == 0 else {
            reportError("Failed to bind: \(errno)")
            Darwin.close(serverFd)
            return
        }

        // Set socket permissions (readable/writable by owner)
        chmod(socketPath, 0o700)

        guard listen(serverFd, 5) == 0 else {
            reportError("Failed to listen: \(errno)")
            Darwin.close(serverFd)
            return
        }

        // Accept connections in a loop
        while !Task.isCancelled {
            var clientAddr = sockaddr_un()
            var clientAddrLen = socklen_t(MemoryLayout<sockaddr_un>.size)

            let clientFd = withUnsafeMutablePointer(to: &clientAddr) { ptr in
                ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockPtr in
                    accept(serverFd, sockPtr, &clientAddrLen)
                }
            }

            guard clientFd >= 0 else {
                if errno == EINTR { continue }
                reportError("Accept error: \(errno)")
                break
            }

            Task {
                await handleConnection(clientFd)
            }
        }

        Darwin.close(serverFd)
        unlink(socketPath)
    }

    private func handleConnection(_ fd: Int32) async {
        // Read data from connection
        var buffer = [UInt8](repeating: 0, count: 65536)
        var totalData = Data()

        while true {
            let bytesRead = recv(fd, &buffer, buffer.count, 0)
            if bytesRead <= 0 { break }
            totalData.append(contentsOf: buffer[0..<bytesRead])

            // Try to parse as JSON - if valid, we have the complete message
            if (try? JSONDecoder().decode(SessionState.self, from: totalData)) != nil {
                break
            }
        }

        guard !totalData.isEmpty else {
            Darwin.close(fd)
            return
        }

        // Decode session state
        let decoder = JSONDecoder()
        guard let state = try? decoder.decode(SessionState.self, from: totalData) else {
            reportError("Failed to decode JSON: \(String(data: totalData, encoding: .utf8) ?? "nil")")
            Darwin.close(fd)
            return
        }

        if state.isWaitingForApproval {
            // For permission requests, pass the fd to SessionManager
            // The fd will be kept open until the user responds
            await MainActor.run {
                sessionManager.handleSessionEvent(state, fileDescriptor: fd)
            }
            // Don't close fd here - SessionManager will close it after sending response
        } else {
            await MainActor.run {
                sessionManager.handleSessionEvent(state)
            }
            Darwin.close(fd)
        }
    }
}
