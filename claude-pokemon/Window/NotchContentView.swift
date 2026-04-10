import SwiftUI

// MARK: - NotchShape with animated corner radii

struct NotchShape: Shape {
    var topCornerRadius: CGFloat
    var bottomCornerRadius: CGFloat

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { .init(topCornerRadius, bottomCornerRadius) }
        set {
            topCornerRadius = newValue.first
            bottomCornerRadius = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let botR = bottomCornerRadius
        // Top edge: flat (blends with physical notch / menu bar)
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        // Right side: straight down, then bottom-right curve
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - botR))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - botR, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        // Bottom edge
        path.addLine(to: CGPoint(x: rect.minX + botR, y: rect.maxY))
        // Bottom-left curve
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - botR),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        // Left side: back to top
        path.closeSubpath()
        return path
    }
}

// MARK: - NotchContentView

struct NotchContentView: View {
    @ObservedObject var sessionManager: SessionManager
    let notchSize: CGSize
    let screenWidth: CGFloat
    let windowHeight: CGFloat
    let currentPokemon: PokemonSpecies
    let language: AppLanguage
    @State private var pokemonExcited: Bool = false

    private var isExpanded: Bool { sessionManager.appState == .permission || sessionManager.appState == .capture }
    private var isActive: Bool { sessionManager.appState == .active || sessionManager.appState == .coding }
    private var showContent: Bool { sessionManager.appState != .idle }

    private var isCoding: Bool {
        sessionManager.sessions.values.contains { $0.isActivelyCoding }
    }

    // Left side: wider to fit basketball + Pokemon scene
    private var leftExpansion: CGFloat {
        if isExpanded { return 0 }
        if isActive { return 100 }
        return 0
    }

    // Right side: small status dot only
    private var rightExpansion: CGFloat {
        if isExpanded { return 0 }
        if isActive { return 20 }
        return 0
    }

    // Total frame width
    private var frameWidth: CGFloat {
        if isExpanded { return min(screenWidth * 0.38, 360) }
        return notchSize.width + leftExpansion + rightExpansion
    }

    // Corner radii
    private var topRadius: CGFloat { isExpanded ? 16 : 4 }
    private var bottomRadius: CGFloat { isExpanded ? 20 : 12 }

    private let openAnimation = Animation.spring(response: 0.42, dampingFraction: 0.8)
    private let closeAnimation = Animation.spring(response: 0.45, dampingFraction: 1.0)
    private var strings: AppStrings { AppStrings(language: language) }

    var body: some View {
        ZStack(alignment: .top) {
            Color.clear

            if showContent {
                notchContent
                    .frame(width: frameWidth)
                    .background(.black)
                    .clipShape(NotchShape(topCornerRadius: topRadius, bottomCornerRadius: bottomRadius))
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(.black)
                            .frame(width: notchSize.width, height: 2)
                    }
                    .shadow(color: isExpanded ? .black.opacity(0.5) : .clear, radius: 6)
                    .animation(isExpanded ? openAnimation : closeAnimation, value: sessionManager.appState)
                    .animation(.smooth, value: isActive)
                    .animation(.smooth, value: isCoding)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    @ViewBuilder
    private var notchContent: some View {
        VStack(spacing: 0) {
            // Header row: notch height, contains side icons when active
            headerRow
                .frame(height: notchSize.height)

            // Expanded content below
            if isExpanded {
                VStack(spacing: 0) {
                    HStack(spacing: 6) {
                        Text(strings.appTitle)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 28)

                    if sessionManager.appState == .capture {
                        CaptureResultView(sessionManager: sessionManager, language: language)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 10)
                    } else {
                        ExpandedNotchView(sessionManager: sessionManager, language: language)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 10)
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .scale(scale: 0.85, anchor: .top).combined(with: .opacity),
                        removal: .opacity.animation(.easeOut(duration: 0.12))
                    )
                )
            }
        }
    }

    // MARK: - Header Row (Dynamic Island style: icon | notch | indicator)

    @ViewBuilder
    private var headerRow: some View {
        if isActive {
            HStack(spacing: 0) {
                // Left side: Pokemon + ball scene
                PokemonBallScene(species: currentPokemon, isCoding: isCoding, excited: $pokemonExcited)
                    .frame(width: leftExpansion, height: notchSize.height)

                // Center: notch space (black, blends with physical notch)
                Rectangle()
                    .fill(.black)
                    .frame(width: notchSize.width - 8)

                // Right side: Pokeball
                PokeballView(size: 14, excited: $pokemonExcited)
                    .frame(width: rightExpansion)
            }
        } else {
            Color.black
        }
    }
}

// MARK: - Capture Result View

struct CaptureResultView: View {
    @ObservedObject var sessionManager: SessionManager
    let language: AppLanguage

    var body: some View {
        if let species = sessionManager.captureResult {
            let strings = AppStrings(language: language)

            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    PokemonPixelArtView(species: species, size: 36)

                    VStack(alignment: .leading, spacing: 3) {
                        if sessionManager.captureIsNew {
                            Text(strings.captureNewPokemonTitle)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(red: 0.95, green: 0.75, blue: 0.25))
                        } else {
                            Text(strings.duplicatePokemonTitle)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Text(species.localizedDisplayName(in: language))
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                        Text("#\(species.dexNumber) \(strings.rarityTitle(species.rarity))")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }

                Button(action: { sessionManager.dismissCapture() }) {
                    Text(strings.okTitle)
                        .font(.system(size: 12, weight: .medium))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(FixedButtonStyle(
                    bgColor: Color(red: 0.85, green: 0.47, blue: 0.34),
                    fgColor: .white
                ))
            }
        }
    }
}

// MARK: - Pokeball View (right side of notch)

struct PokeballView: View {
    let size: CGFloat
    @Binding var excited: Bool
    @State private var wiggle: Double = 0
    @State private var wiggleCount: Int = 0
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Canvas { context, canvasSize in
            let s = min(canvasSize.width, canvasSize.height)
            let cx = canvasSize.width / 2
            let cy = canvasSize.height / 2
            let r = s / 2

            // Top half — red
            var topArc = Path()
            topArc.addArc(center: CGPoint(x: cx, y: cy), radius: r,
                          startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            topArc.addLine(to: CGPoint(x: cx + r, y: cy))
            topArc.addLine(to: CGPoint(x: cx - r, y: cy))
            topArc.closeSubpath()
            context.fill(topArc, with: .color(Color(red: 0.9, green: 0.2, blue: 0.2)))

            // Bottom half — white
            var botArc = Path()
            botArc.addArc(center: CGPoint(x: cx, y: cy), radius: r,
                          startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
            botArc.addLine(to: CGPoint(x: cx - r, y: cy))
            botArc.closeSubpath()
            context.fill(botArc, with: .color(.white))

            // Center band — dark line
            var band = Path()
            band.move(to: CGPoint(x: cx - r, y: cy - 1))
            band.addLine(to: CGPoint(x: cx + r, y: cy - 1))
            band.addLine(to: CGPoint(x: cx + r, y: cy + 1))
            band.addLine(to: CGPoint(x: cx - r, y: cy + 1))
            band.closeSubpath()
            context.fill(band, with: .color(Color(white: 0.15)))

            // Center button — outer ring
            let ringR = r * 0.35
            var ring = Path()
            ring.addEllipse(in: CGRect(x: cx - ringR, y: cy - ringR, width: ringR * 2, height: ringR * 2))
            context.fill(ring, with: .color(Color(white: 0.15)))

            // Center button — inner circle
            let btnR = r * 0.22
            var btn = Path()
            btn.addEllipse(in: CGRect(x: cx - btnR, y: cy - btnR, width: btnR * 2, height: btnR * 2))
            context.fill(btn, with: .color(.white))

            // Outline
            context.stroke(Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: s, height: s)),
                          with: .color(Color(white: 0.15)),
                          style: StrokeStyle(lineWidth: max(1, s * 0.06)))
        }
        .frame(width: size, height: size)
        .scaleEffect(scale)
        .rotationEffect(.degrees(wiggle))
        .onChange(of: excited) { _, isExcited in
            if isExcited { startWiggle() }
        }
    }

    private func startWiggle() {
        wiggleCount = 0
        doWiggle()
    }

    private func doWiggle() {
        guard wiggleCount < 6 else {
            withAnimation(.spring(response: 0.2)) {
                wiggle = 0; scale = 1.0
            }
            // Reset excited after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { excited = false }
            return
        }
        let angle: Double = wiggleCount % 2 == 0 ? 25 : -25
        withAnimation(.spring(response: 0.08, dampingFraction: 0.3)) {
            wiggle = angle
            scale = 1.2
        }
        wiggleCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) { doWiggle() }
    }
}

// MARK: - Claude Spinner (菊花 loading indicator)

struct ClaudeSpinner: View {
    let size: CGFloat
    let spinning: Bool
    @State private var phase: Int = 0

    private let color = Color(red: 0.85, green: 0.47, blue: 0.34)
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let petalCount = 8

    var body: some View {
        ZStack {
            // Round background
            Circle()
                .fill(Color(white: 0.15))
                .frame(width: size, height: size)

            // Spinner petals
            Canvas { context, canvasSize in
                let cx = canvasSize.width / 2
                let cy = canvasSize.height / 2
                let innerR = canvasSize.width * 0.18
                let outerR = canvasSize.width * 0.4
                let lineW = max(1.5, canvasSize.width * 0.1)

                for i in 0..<petalCount {
                    let angle = Angle.degrees(Double(i) * 360.0 / Double(petalCount) - 90)
                    let cos = cos(angle.radians)
                    let sin = sin(angle.radians)

                    let start = CGPoint(x: cx + innerR * cos, y: cy + innerR * sin)
                    let end = CGPoint(x: cx + outerR * cos, y: cy + outerR * sin)

                    var path = Path()
                    path.move(to: start)
                    path.addLine(to: end)

                    let opacity = petalOpacity(index: i)
                    context.stroke(path, with: .color(color.opacity(opacity)),
                                  style: StrokeStyle(lineWidth: lineW, lineCap: .round))
                }
            }
            .frame(width: size, height: size)
        }
        .onReceive(timer) { _ in
            if spinning { phase += 1 }
        }
    }

    private func petalOpacity(index: Int) -> Double {
        if spinning {
            // Trailing fade: brightest petal chases around
            let dist = (petalCount + index - (phase % petalCount)) % petalCount
            return 1.0 - Double(dist) * 0.09
        }
        return 0.5
    }
}

// MARK: - Pokemon + Bouncy Ball Physics Scene

struct PokemonBallScene: View {
    let species: PokemonSpecies
    let isCoding: Bool
    @Binding var excited: Bool

    // Physics state
    @State private var ballX: CGFloat = 8
    @State private var ballY: CGFloat = 0
    @State private var velX: CGFloat = 1.5
    @State private var velY: CGFloat = 0
    @State private var squashX: CGFloat = 1.0
    @State private var squashY: CGFloat = 1.0
    @State private var ballAngle: Double = 0

    // Pokemon reaction
    @State private var pokeRotation: Double = 0
    @State private var pokeOffsetY: CGFloat = 0
    @State private var pokeScale: CGFloat = 1.0
    @State private var pokeAction: Int = 0  // 0=idle, 1=kick, 2=headbutt, 3=jump
    @State private var exciteTimer: Int = 0  // countdown for excitement shaking

    // Idle breathing
    @State private var frame: Int = 0

    private let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

    // Scene bounds
    private let sceneW: CGFloat = 96
    private let sceneH: CGFloat = 32
    private let ballR: CGFloat = 8
    private let gravity: CGFloat = 0.12
    private let bounceDamp: CGFloat = 0.6
    private let friction: CGFloat = 0.97
    // Pokemon sits at right side of scene
    private let pokeX: CGFloat = 30

    var body: some View {
        ZStack {
            // Ball
            ClaudeSpinner(size: ballR * 2, spinning: isCoding)
                .rotationEffect(.degrees(ballAngle))
                .scaleEffect(x: squashX, y: squashY)
                .position(x: ballX, y: sceneH / 2 + ballY)

            // Pokemon
            PokemonPixelArtView(species: species, size: 22)
                .scaleEffect(pokeScale)
                .rotationEffect(.degrees(pokeRotation))
                .offset(y: pokeOffsetY)
                .position(x: pokeX + 11, y: sceneH / 2)
        }
        .frame(width: sceneW, height: sceneH)
        .onReceive(timer) { _ in tick() }
        .onReceive(NotificationCenter.default.publisher(for: .pokemonTapped)) { _ in smash() }
    }

    /// Strong kick — Pokemon smashes the ball hard and gets excited
    private func smash() {
        // Big random impulse
        velX = CGFloat.random(in: -3.0...(-1.5))
        velY = CGFloat.random(in: -4.0...(-2.0))

        // Strong squash
        squashX = 1.4; squashY = 0.6

        // Pokemon gets excited — rapid shaking for ~1 second (30 frames at 0.03s)
        exciteTimer = 30
        pokeScale = 1.25

        // Trigger pokeball wiggle
        excited = true
    }

    private func tick() {
        frame += 1
        if isCoding {
            physicsTick()
        } else {
            idleTick()
        }

        // Excitement animation: rapid shaking + bouncing
        if exciteTimer > 0 {
            exciteTimer -= 1
            let shake = exciteTimer % 2 == 0 ? 15.0 : -15.0
            pokeRotation = shake
            pokeOffsetY = exciteTimer % 4 < 2 ? -3 : 1
            pokeScale = 1.0 + CGFloat(exciteTimer) / 60.0 * 0.3  // scale down from 1.3 to 1.0
        } else if pokeAction == 0 {
            pokeScale += (1.0 - pokeScale) * 0.15
        }
    }

    private func physicsTick() {
        var vy = velY + gravity
        var vx = velX * friction
        var bx = ballX + vx
        var by = ballY + vy
        var didBounce = false
        var strength: CGFloat = 0

        let floorY = sceneH / 2 - ballR
        if by > floorY {
            by = floorY; strength = abs(vy)
            vy = -abs(vy) * bounceDamp
            vx += CGFloat.random(in: -0.3...0.3)
            didBounce = true
        }
        if by < -sceneH / 2 + ballR {
            by = -sceneH / 2 + ballR
            vy = abs(vy) * bounceDamp
            didBounce = true; strength = abs(vy)
        }
        if bx < ballR {
            bx = ballR
            vx = abs(vx) * bounceDamp + 0.15
            didBounce = true; strength = abs(velX)
        }
        let pokeLeft = pokeX + 6
        if bx > pokeLeft - ballR {
            bx = pokeLeft - ballR
            vx = -abs(vx) * bounceDamp - CGFloat.random(in: 0.3...1.0)
            vy += CGFloat.random(in: -1.5...(-0.2))
            didBounce = true; strength = 1.5
            let act = Int.random(in: 1...3)
            pokeAction = act
            switch act {
            case 1: pokeRotation = -15; pokeOffsetY = 2
            case 2: pokeRotation = 12; pokeOffsetY = -2
            case 3: pokeRotation = -5; pokeOffsetY = -4
            default: break
            }
        }
        if frame % 90 == 0 {
            vx += CGFloat.random(in: -0.5...0.5)
            vy += CGFloat.random(in: -1.0...0)
        }
        vx = max(-2, min(2, vx))
        vy = max(-3, min(3, vy))

        if didBounce && strength > 0.5 {
            let s = min(strength / 4.0, 0.3)
            squashX = 1.0 + s; squashY = 1.0 - s
        } else {
            squashX += (1.0 - squashX) * 0.2
            squashY += (1.0 - squashY) * 0.2
        }

        ballX = bx; ballY = by; velX = vx; velY = vy
        // Spin based on velocity
        ballAngle += Double(vx) * 3.0

        if pokeAction > 0 {
            // Recovering from ball collision reaction
            pokeRotation += (0 - pokeRotation) * 0.15
            pokeOffsetY += (0 - pokeOffsetY) * 0.15
            if abs(pokeRotation) < 0.5 { pokeAction = 0 }
        } else if exciteTimer <= 0 {
            // Coding animation: bounce + sway like typing
            let bounce = sin(Double(frame) * 0.25) // fast bob
            let sway = sin(Double(frame) * 0.12) * 5.0 // gentle sway
            pokeOffsetY = CGFloat(bounce) * 2.5
            pokeRotation = sway
        }
    }

    private func idleTick() {
        let breath = sin(Double(frame) * 0.04)

        // Poll-style hop every 3 seconds so the Pokemon visibly "moves" while Claude is idle.
        // Timer ticks every 0.03s → 100 frames ≈ 3s. Hop occupies the first 20 frames of each cycle.
        let hopCycle = frame % 100
        let hopLift: CGFloat
        let hopTilt: Double
        if hopCycle < 20 {
            let t = Double(hopCycle) / 20.0
            hopLift = CGFloat(-sin(t * .pi) * 5.0)
            hopTilt = sin(t * .pi * 2) * 6.0
        } else {
            hopLift = 0
            hopTilt = 0
        }

        pokeOffsetY = CGFloat(breath) * 1.5 + hopLift
        pokeRotation = hopTilt
        let restX: CGFloat = 14
        let restY: CGFloat = sceneH / 2 - ballR
        ballX += (restX - ballX) * 0.05
        ballY += (restY - ballY) * 0.05
        velX = 0; velY = 0
        squashX += (1.0 - squashX) * 0.1
        squashY += (1.0 - squashY) * 0.1
        ballAngle += 0.3  // gentle idle spin
    }
}
