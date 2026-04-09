import Foundation

/// Matches the JSON sent by claude-island-state.py
struct SessionState: Codable, Identifiable {
    let sessionId: String
    let cwd: String
    let event: String
    let pid: Int
    let tty: String?
    let ttyValid: Bool
    let sessionActive: Bool
    let status: String
    let tool: String?
    let toolInput: [String: ToolInputValue]
    let toolUseId: String?
    let notificationType: String?
    let message: String?

    var id: String { sessionId }

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case cwd, event, pid, tty
        case ttyValid = "tty_valid"
        case sessionActive = "session_active"
        case status, tool
        case toolInput = "tool_input"
        case toolUseId = "tool_use_id"
        case notificationType = "notification_type"
        case message
    }
}

/// Flexible JSON value type for tool_input fields
enum ToolInputValue: Codable, Hashable {
    case string(String)
    case int(Int)
    case bool(Bool)
    case array([String])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let v = try? container.decode(Bool.self) {
            self = .bool(v)
        } else if let v = try? container.decode(Int.self) {
            self = .int(v)
        } else if let v = try? container.decode(String.self) {
            self = .string(v)
        } else if let v = try? container.decode([String].self) {
            self = .array(v)
        } else {
            self = .null
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let v): try container.encode(v)
        case .int(let v): try container.encode(v)
        case .bool(let v): try container.encode(v)
        case .array(let v): try container.encode(v)
        case .null: try container.encodeNil()
        }
    }

    var stringValue: String? {
        if case .string(let v) = self { return v }
        return nil
    }
}

/// Permission decision sent back to the hook
struct PermissionDecision: Codable {
    let decision: String
    var reason: String?
}

/// Active permission request with its socket connection
struct PermissionRequest: Identifiable {
    let id = UUID()
    let state: SessionState
    let fileDescriptor: Int32

    var toolName: String { state.tool ?? "Unknown" }

    var summary: String {
        if let filePath = state.toolInput["file_path"]?.stringValue {
            let fileName = (filePath as NSString).lastPathComponent
            return "\(toolName): \(fileName)"
        }
        if let command = state.toolInput["command"]?.stringValue {
            let truncated = command.prefix(60)
            return "\(toolName): \(truncated)"
        }
        return toolName
    }

    var detail: String {
        if let filePath = state.toolInput["file_path"]?.stringValue {
            return filePath
        }
        if let command = state.toolInput["command"]?.stringValue {
            return String(command.prefix(120))
        }
        return ""
    }
}
