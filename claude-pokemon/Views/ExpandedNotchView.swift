import SwiftUI

/// Expanded notch view showing permission request with Allow/Deny buttons
struct ExpandedNotchView: View {
    @ObservedObject var sessionManager: SessionManager

    var body: some View {
        if let request = sessionManager.activePermissionRequest {
            VStack(spacing: 10) {
                // Tool info
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(request.summary)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        if !request.detail.isEmpty {
                            Text(request.detail)
                                .font(.system(size: 10, weight: .regular, design: .monospaced))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                    }

                    Spacer()
                }

                // Action buttons — custom styles to avoid focus/hover changes
                HStack(spacing: 12) {
                    Button(action: { sessionManager.resolvePermission(allow: false) }) {
                        Text("Deny")
                            .font(.system(size: 12, weight: .medium))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(FixedButtonStyle(
                        bgColor: Color(white: 0.28),
                        fgColor: .white.opacity(0.9)
                    ))

                    Button(action: { sessionManager.resolvePermission(allow: true) }) {
                        Text("Allow")
                            .font(.system(size: 12, weight: .medium))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(FixedButtonStyle(
                        bgColor: Color(red: 0.85, green: 0.55, blue: 0.35),
                        fgColor: .white
                    ))
                }
            }
            .padding(.vertical, 4)
        }
    }

}

/// Custom button style that never changes appearance on hover/focus/window state
struct FixedButtonStyle: ButtonStyle {
    let bgColor: Color
    let fgColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(fgColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(bgColor.opacity(configuration.isPressed ? 0.7 : 1.0))
            )
    }
}
