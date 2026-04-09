import SwiftUI

/// Pokemon animation inside the notch header row
struct CollapsedNotchView: View {
    @ObservedObject var sessionManager: SessionManager
    let notchWidth: CGFloat

    @State private var frameIndex: Int = 0
    @State private var xOffset: CGFloat = 0
    @State private var walkingRight: Bool = true

    private let timer = Timer.publish(every: 1.0 / 10.0, on: .main, in: .common).autoconnect()

    private var isCoding: Bool {
        sessionManager.sessions.values.contains { $0.status == "processing" || $0.status == "running_tool" }
    }

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            if isCoding {
                CodingPokemonView(frameIndex: frameIndex)
                    .offset(x: xOffset)
            } else {
                IdlePokemonView(frameIndex: frameIndex)
                    .offset(x: xOffset)
            }
            Spacer()
        }
        .onReceive(timer) { _ in
            frameIndex += 1
            updatePosition()
        }
    }

    private func updatePosition() {
        if isCoding {
            let sway = sin(Double(frameIndex) * 0.08) * 8
            withAnimation(.linear(duration: 0.1)) {
                xOffset = CGFloat(sway)
            }
        } else {
            let speed: CGFloat = 0.5
            let range = (notchWidth / 2) - 16
            if walkingRight {
                xOffset += speed
                if xOffset > range { walkingRight = false }
            } else {
                xOffset -= speed
                if xOffset < -range { walkingRight = true }
            }
        }
    }
}

// MARK: - Idle Pokemon

struct IdlePokemonView: View {
    let frameIndex: Int
    private var breathOffset: CGFloat { CGFloat(sin(Double(frameIndex) * 0.15)) * 1.5 }
    private var isBlinking: Bool { frameIndex % 40 < 2 }

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color(red: 0.85, green: 0.55, blue: 0.35))
                .frame(width: 14, height: 16)
                .offset(y: 4 - breathOffset)
            Ellipse()
                .fill(Color(red: 0.85, green: 0.55, blue: 0.35))
                .frame(width: 18, height: 14)
                .offset(y: -6 - breathOffset)
            HStack(spacing: 4) {
                Ellipse().fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .frame(width: 3.5, height: isBlinking ? 1.5 : 4)
                Ellipse().fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .frame(width: 3.5, height: isBlinking ? 1.5 : 4)
            }
            .offset(y: -6 - breathOffset)
            HStack(spacing: 10) {
                Circle().fill(Color(red: 0.95, green: 0.78, blue: 0.60)).frame(width: 5, height: 5)
                Circle().fill(Color(red: 0.95, green: 0.78, blue: 0.60)).frame(width: 5, height: 5)
            }
            .offset(y: -14 - breathOffset)
            HStack(spacing: 3) {
                Ellipse().fill(Color(red: 0.65, green: 0.38, blue: 0.22)).frame(width: 6, height: 4)
                Ellipse().fill(Color(red: 0.65, green: 0.38, blue: 0.22)).frame(width: 6, height: 4)
            }
            .offset(y: 11)
        }
        .frame(width: 28, height: 28)
    }
}

// MARK: - Coding Pokemon

struct CodingPokemonView: View {
    let frameIndex: Int
    private var typingBounce: CGFloat { (frameIndex % 4 < 2) ? 0 : -1 }
    private var cursorVisible: Bool { frameIndex % 8 < 4 }

    var body: some View {
        ZStack {
            // Chair
            Rectangle().fill(Color(white: 0.35)).frame(width: 2, height: 12).offset(x: -8, y: 4)
            Rectangle().fill(Color(white: 0.35)).frame(width: 2, height: 8).offset(x: 1, y: 6)
            Rectangle().fill(Color(white: 0.4)).frame(width: 14, height: 2.5).offset(x: -4, y: 2)
            Rectangle().fill(Color(white: 0.35)).frame(width: 2, height: 14).offset(x: -10, y: -2)

            // Desk + Monitor
            Rectangle().fill(Color(white: 0.25)).frame(width: 2, height: 12).offset(x: 8, y: 4)
            Rectangle().fill(Color(white: 0.3)).frame(width: 14, height: 2).offset(x: 8, y: 0)
            RoundedRectangle(cornerRadius: 1).fill(Color(white: 0.12)).frame(width: 11, height: 9).offset(x: 9, y: -7)
            RoundedRectangle(cornerRadius: 1).fill(Color(red: 0.2, green: 0.7, blue: 0.5)).frame(width: 9, height: 7).offset(x: 9, y: -7)
            Rectangle().fill(Color.white.opacity(0.8)).frame(width: 5, height: 1).offset(x: 7, y: -9)
            Rectangle().fill(Color.white.opacity(0.6)).frame(width: 3, height: 1).offset(x: 8, y: -7)
            if cursorVisible {
                Rectangle().fill(Color.white).frame(width: 2, height: 1).offset(x: 7, y: -5)
            }

            // Body
            Ellipse().fill(Color(red: 0.85, green: 0.55, blue: 0.35))
                .frame(width: 12, height: 12).offset(x: -3, y: 0 + typingBounce)
            // Head
            Ellipse().fill(Color(red: 0.85, green: 0.55, blue: 0.35))
                .frame(width: 13, height: 11).offset(x: -2, y: -8 + typingBounce)
            // Eye
            Ellipse().fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                .frame(width: 3, height: 3.5).offset(x: 1, y: -8 + typingBounce)
            // Ear
            Circle().fill(Color(red: 0.95, green: 0.78, blue: 0.60))
                .frame(width: 4, height: 4).offset(x: -5, y: -14 + typingBounce)
            // Arm
            RoundedRectangle(cornerRadius: 1).fill(Color(red: 0.65, green: 0.38, blue: 0.22))
                .frame(width: 7, height: 2.5).offset(x: 3, y: -1 + typingBounce)
        }
        .frame(width: 32, height: 28)
    }
}
