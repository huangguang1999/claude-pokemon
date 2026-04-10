import AppKit
import SwiftUI
import Combine

/// NSPanel subclass: ignoresMouseEvents by default, with click passthrough when opened.
final class NotchPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    // Prevent the system from constraining window to visible area
    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
        return frameRect
    }

    override func sendEvent(_ event: NSEvent) {
        switch event.type {
        case .leftMouseDown, .leftMouseUp, .rightMouseDown, .rightMouseUp:
            if let contentView = self.contentView,
               contentView.hitTest(event.locationInWindow) == nil {
                ignoresMouseEvents = true
                DispatchQueue.main.async { [weak self] in
                    self?.repostClick(event)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.ignoresMouseEvents = false
                    }
                }
                return
            }
        default:
            break
        }
        super.sendEvent(event)
    }

    private func repostClick(_ event: NSEvent) {
        if let cgEvent = event.cgEvent {
            cgEvent.post(tap: .cghidEventTap)
        }
    }
}

extension Notification.Name {
    static let pokemonTapped = Notification.Name("pokemonTapped")
}

final class NotchWindow {
    private let panel: NotchPanel
    private var cancellables = Set<AnyCancellable>()
    private var clickMonitor: Any?

    init(
        notchBounds: ScreenGeometry.NotchBounds,
        sessionManager: SessionManager,
        screen: NSScreen,
        pokemon: PokemonSpecies,
        language: AppLanguage
    ) {
        // Window only covers the notch area + expansion, not full screen width.
        // This prevents overlapping with right-side menu bar items.
        let windowHeight: CGFloat = 350
        let windowWidth: CGFloat = 500  // enough for expanded popup (~360pt) + margins
        let notchCenterX = screen.frame.origin.x + CGFloat(notchBounds.x) + CGFloat(notchBounds.width) / 2
        let windowFrame = NSRect(
            x: notchCenterX - windowWidth / 2,
            y: screen.frame.maxY - windowHeight,
            width: windowWidth,
            height: windowHeight
        )

        panel = NotchPanel(
            contentRect: windowFrame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        panel.level = NSWindow.Level(rawValue: NSWindow.Level.screenSaver.rawValue - 1)

        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = false
        panel.isMovable = false
        panel.isFloatingPanel = true
        panel.becomesKeyOnlyIfNeeded = true
        panel.collectionBehavior = [.fullScreenAuxiliary, .stationary, .canJoinAllSpaces, .ignoresCycle]
        panel.ignoresMouseEvents = true

        let contentView = NotchContentView(
            sessionManager: sessionManager,
            notchSize: CGSize(width: notchBounds.width, height: notchBounds.height),
            screenWidth: windowWidth,
            windowHeight: windowHeight,
            currentPokemon: pokemon,
            language: language
        )

        let hostingView = PassThroughHostingView(rootView: contentView)
        hostingView.screenWidth = windowWidth
        hostingView.windowHeight = windowHeight
        hostingView.notchSize = CGSize(width: notchBounds.width, height: notchBounds.height)
        hostingView.sessionManager = sessionManager
        panel.contentView = hostingView

        // Toggle ignoresMouseEvents based on state
        Task { @MainActor in
            sessionManager.$appState
                .receive(on: RunLoop.main)
                .sink { [weak self] state in
                    let interactive = (state == .permission || state == .capture)
                    self?.panel.ignoresMouseEvents = !interactive
                    if interactive {
                        self?.panel.makeKey()
                    }
                }
                .store(in: &cancellables)
        }

        // Global click monitor for Pokemon tap (menu bar blocks normal events)
        let pokemonScreenRect = NSRect(
            x: windowFrame.origin.x,
            y: screen.frame.maxY - CGFloat(notchBounds.height) - 5,
            width: CGFloat(notchBounds.width) / 2 + 120,
            height: CGFloat(notchBounds.height) + 10
        )
        clickMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { _ in
            let screenLoc = NSEvent.mouseLocation
            if pokemonScreenRect.contains(screenLoc) {
                Task { @MainActor in
                    let state = sessionManager.appState
                    if state == .active || state == .coding {
                        NotificationCenter.default.post(name: .pokemonTapped, object: nil)
                    }
                }
            }
        }
    }

    func orderFrontRegardless() { panel.orderFrontRegardless() }
    var frame: NSRect { panel.frame }

    func close() {
        if let clickMonitor {
            NSEvent.removeMonitor(clickMonitor)
            self.clickMonitor = nil
        }
        cancellables.removeAll()
        panel.orderOut(nil)
        panel.close()
    }

    deinit {
        if let clickMonitor {
            NSEvent.removeMonitor(clickMonitor)
        }
    }
}

/// Pass-through hosting view: only accepts hits inside the active content rect.
final class PassThroughHostingView: NSHostingView<NotchContentView> {
    var screenWidth: CGFloat = 0
    var windowHeight: CGFloat = 0
    var notchSize: CGSize = .zero
    weak var sessionManager: SessionManager?

    override func hitTest(_ point: NSPoint) -> NSView? {
        let rect = activeHitRect()
        guard rect.contains(point) else { return nil }
        return super.hitTest(point)
    }

    private func activeHitRect() -> CGRect {
        guard let sm = sessionManager else { return .zero }
        let cx = screenWidth / 2

        switch sm.appState {
        case .idle:
            return .zero
        case .active, .coding:
            // Full width, top area — cover entire notch + side scenes
            return CGRect(x: 0, y: windowHeight - 50, width: screenWidth, height: 50)
        case .permission, .capture:
            // Wider rect for the expanded panel
            let w: CGFloat = 400
            let h: CGFloat = 180
            return CGRect(x: cx - w / 2, y: windowHeight - h, width: w, height: h)
        }
    }
}
