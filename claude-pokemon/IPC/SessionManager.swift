import Foundation
import AppKit
import SwiftUI

enum AppState: Equatable {
    case idle       // No sessions at all
    case active     // Has sessions, Pokemon visible (idle/walking animation)
    case coding     // Actively processing, Pokemon coding animation
    case permission // Permission prompt expanded
    case capture    // Wild Pokemon appeared!
}

@MainActor
final class SessionManager: ObservableObject {
    @Published var sessions: [String: SessionState] = [:]
    @Published var activePermissionRequest: PermissionRequest?
    @Published var appState: AppState = .idle

    private let expandAnimation = Animation.spring(response: 0.42, dampingFraction: 0.8)
    private let collapseAnimation = Animation.spring(response: 0.35, dampingFraction: 1.0)

    /// Animate appState transitions
    private func setAppState(_ newState: AppState) {
        let expanding = (newState == .permission || newState == .capture) && (appState != .permission && appState != .capture)
        let collapsing = (newState != .permission && newState != .capture) && (appState == .permission || appState == .capture)
        withAnimation(expanding ? expandAnimation : collapsing ? collapseAnimation : .smooth) {
            appState = newState
        }
    }

    // Capture system
    @Published var captureResult: PokemonSpecies?
    @Published var captureIsNew: Bool = false
    var capturePoints: Int {
        get { UserDefaults.standard.integer(forKey: "capturePoints") }
        set { UserDefaults.standard.set(newValue, forKey: "capturePoints") }
    }
    var pendingCaptures: Int {
        get { UserDefaults.standard.integer(forKey: "pendingCaptures") }
        set { UserDefaults.standard.set(newValue, forKey: "pendingCaptures") }
    }

    /// Queue of pending permission requests (if multiple arrive)
    private var permissionQueue: [PermissionRequest] = []

    /// Whether a terminal app is currently the frontmost application
    private var isTerminalActive: Bool = false
    private var workspaceObserver: Any?

    /// Known terminal app bundle identifiers
    private static let terminalBundleIDs: Set<String> = [
        "com.apple.Terminal",
        "com.googlecode.iterm2",
        "dev.warp.Warp-Stable",
        "dev.warp.Warp",
        "net.kovidgoyal.kitty",
        "co.zeit.hyper",
        "com.github.wez.wezterm",
        "io.alacritty",
        "com.raggesilver.BlackBox",
        "com.mitchellh.ghostty",
    ]

    init() {
        // Give 10 capture chances on first launch
        if !UserDefaults.standard.bool(forKey: "initialCapturesGranted") {
            pendingCaptures += 10
            UserDefaults.standard.set(true, forKey: "initialCapturesGranted")
        }
        setupFrontmostAppMonitor()
    }

    // MARK: - Frontmost App Monitoring

    private func setupFrontmostAppMonitor() {
        // Check initial state
        updateTerminalActive()

        // Observe app activation changes
        workspaceObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleAppActivation()
            }
        }
    }

    private func updateTerminalActive() {
        if let frontApp = NSWorkspace.shared.frontmostApplication,
           let bundleID = frontApp.bundleIdentifier {
            isTerminalActive = Self.terminalBundleIDs.contains(bundleID)
        } else {
            isTerminalActive = false
        }
    }

    private func handleAppActivation() {
        let wasTerminal = isTerminalActive
        updateTerminalActive()

        // If switched TO terminal while permission popup is showing, auto-collapse
        if !wasTerminal && isTerminalActive && activePermissionRequest != nil {
            logDebug("[SessionManager] Terminal became active, dismissing permission popup → ask")
            dismissPermissionAsAsk()
        }
    }

    // MARK: - Session Events

    func handleSessionEvent(_ state: SessionState, fileDescriptor: Int32? = nil) {
        logDebug("[SessionManager] event=\(state.event) status=\(state.status) session=\(state.sessionId) hasPermission=\(activePermissionRequest != nil) terminalActive=\(isTerminalActive)")

        // If we have a pending permission, don't let other events override the state
        if activePermissionRequest != nil && state.status != "waiting_for_approval" && state.status != "ended" {
            sessions[state.sessionId] = state
            logDebug("[SessionManager] Ignoring state update, permission pending")
            return
        }

        // Accumulate capture points on tool usage
        if state.event == "PostToolUse" {
            addCapturePoints(for: state.tool)
            logDebug("[Capture] points=\(capturePoints) pending=\(pendingCaptures) tool=\(state.tool ?? "?")")
        }

        switch state.status {
        case "ended":
            sessions.removeValue(forKey: state.sessionId)

        case "waiting_for_approval":
            sessions[state.sessionId] = state
            if let fd = fileDescriptor {
                // If terminal is active, don't intercept — let CLI handle it
                if isTerminalActive {
                    logDebug("[SessionManager] Terminal is active, passing permission to CLI")
                    sendAskDecision(fd: fd)
                    return
                }

                let request = PermissionRequest(state: state, fileDescriptor: fd)
                if activePermissionRequest == nil {
                    activePermissionRequest = request
                    setAppState(.permission)
                } else {
                    permissionQueue.append(request)
                }
            }
            return

        default:
            sessions[state.sessionId] = state
        }

        updateAppState()
    }

    func resolvePermission(allow: Bool) {
        guard let request = activePermissionRequest else { return }

        let decision = PermissionDecision(
            decision: allow ? "allow" : "deny",
            reason: allow ? nil : "Denied by user via Claude Pokemon"
        )

        if let data = try? JSONEncoder().encode(decision) {
            _ = data.withUnsafeBytes { bytes in
                send(request.fileDescriptor, bytes.baseAddress!, bytes.count, 0)
            }
        }
        close(request.fileDescriptor)

        activePermissionRequest = nil
        if !permissionQueue.isEmpty {
            activePermissionRequest = permissionQueue.removeFirst()
            appState = .permission
        } else {
            updateAppState()
        }
    }

    // MARK: - Private

    /// Dismiss current permission popup and tell hook to let CLI handle it
    private func dismissPermissionAsAsk() {
        guard let request = activePermissionRequest else { return }
        sendAskDecision(fd: request.fileDescriptor)

        activePermissionRequest = nil
        // Also dismiss any queued permissions back to CLI
        for queued in permissionQueue {
            sendAskDecision(fd: queued.fileDescriptor)
        }
        permissionQueue.removeAll()
        updateAppState()
    }

    /// Send "ask" decision — hook will fall back to CLI's native permission UI
    private func sendAskDecision(fd: Int32) {
        let decision = PermissionDecision(decision: "ask", reason: nil)
        if let data = try? JSONEncoder().encode(decision) {
            _ = data.withUnsafeBytes { bytes in
                send(fd, bytes.baseAddress!, bytes.count, 0)
            }
        }
        close(fd)
    }

    // MARK: - Capture System

    /// Add points from tool usage
    func addCapturePoints(for tool: String?) {
        let pts: Int
        switch tool {
        case "Edit", "Write", "Bash": pts = 3
        case "Read", "Grep", "Glob": pts = 1
        default: pts = 1
        }
        capturePoints += pts
        if capturePoints >= 100 {
            capturePoints -= 100
            pendingCaptures += 1
            logDebug("[Capture] Earned capture chance! pending=\(pendingCaptures)")
        }
    }

    /// Trigger a capture (roll a Pokemon)
    func triggerCapture() {
        let rolled = PokemonGacha.roll()
        let caught = PokemonStorage.caughtList()
        captureIsNew = !caught.contains(rolled.rawValue)

        if captureIsNew {
            PokemonStorage.addCaught(rolled)
        } else {
            // Duplicate → bonus points
            capturePoints += 20
        }

        if pendingCaptures > 0 {
            pendingCaptures -= 1
        }

        captureResult = rolled
        setAppState(.capture)
        logDebug("[Capture] Rolled: \(rolled.displayName) isNew=\(captureIsNew)")
    }

    /// Dismiss capture result
    func dismissCapture() {
        captureResult = nil
        updateAppState()
    }

    private func updateAppState() {
        if captureResult != nil {
            setAppState(.capture)
            return
        }
        if activePermissionRequest != nil {
            setAppState(.permission)
            return
        }

        let hasActiveCoding = sessions.values.contains { state in
            state.status == "processing" || state.status == "running_tool"
        }

        let newState: AppState
        if hasActiveCoding {
            newState = .coding
        } else if !sessions.isEmpty {
            newState = .active
        } else {
            newState = .idle
        }
        logDebug("[SessionManager] appState: \(appState) -> \(newState), sessions: \(sessions.count)")
        setAppState(newState)
    }
}
