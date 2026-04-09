import AppKit
import SwiftUI

/// Create NSImage of Pokemon pixel art for status bar
func pokemonStatusBarImage(species: PokemonSpecies, size: CGFloat) -> NSImage {
    let grid = species.pixelGrid
    let pal = species.palette
    let rows = grid.count
    let cols = grid.first?.count ?? 8

    let img = NSImage(size: NSSize(width: size, height: size))
    img.lockFocus()
    if let ctx = NSGraphicsContext.current?.cgContext {
        let cellW = size / CGFloat(cols)
        let cellH = size / CGFloat(rows)
        for (row, line) in grid.enumerated() {
            for (col, ch) in line.enumerated() {
                guard ch != ".", let rgb = pal[ch] else { continue }
                ctx.setFillColor(CGColor(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0))
                // Flip Y: NSImage coordinates are bottom-up
                let rect = CGRect(
                    x: CGFloat(col) * cellW,
                    y: size - CGFloat(row + 1) * cellH,
                    width: cellW + 0.5,
                    height: cellH + 0.5
                )
                ctx.fill(rect)
            }
        }
    }
    img.unlockFocus()
    return img
}

func logDebug(_ msg: String) {
    let line = "[\(Date())] \(msg)\n"
    let path = "/tmp/claude-pokemon-debug.log"
    if let fh = FileHandle(forWritingAtPath: path) {
        fh.seekToEndOfFile()
        fh.write(line.data(using: .utf8)!)
        fh.closeFile()
    } else {
        FileManager.default.createFile(atPath: path, contents: line.data(using: .utf8))
    }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var notchWindow: NotchWindow?
    private let sessionManager = SessionManager()
    private var socketServer: SocketServer?
    private var currentPokemon: PokemonSpecies = .pikachu

    func applicationDidFinishLaunching(_ notification: Notification) {
        logDebug("App launched")
        currentPokemon = PokemonGacha.loadOrGenerate()
        PokemonStorage.addCaught(currentPokemon)  // ensure starter is in collection
        logDebug("Pokemon: \(currentPokemon.displayName) (\(currentPokemon.japaneseName)) [\(currentPokemon.rarity.rawValue) \(currentPokemon.rarity.stars)]")
        setupStatusItem()
        startSocketServer()

        // Delay window setup slightly to ensure screen APIs are fully available
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.setupNotchWindow()
        }
    }

    private func setupStatusItem() {
        if statusItem == nil {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        }
        if let button = statusItem.button {
            button.image = pokemonStatusBarImage(species: currentPokemon, size: 18)
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Claude Pokemon", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())

        // Current Pokemon info
        let pokemonInfo = NSMenuItem(title: "当前: \(currentPokemon.japaneseName) (\(currentPokemon.displayName)) #\(currentPokemon.dexNumber)", action: nil, keyEquivalent: "")
        menu.addItem(pokemonInfo)
        let rarityInfo = NSMenuItem(title: "\(currentPokemon.rarity.rawValue) \(currentPokemon.rarity.stars)", action: nil, keyEquivalent: "")
        menu.addItem(rarityInfo)
        menu.addItem(NSMenuItem.separator())

        // Pokedex submenu — only caught, in capture order
        let caught = PokemonStorage.caughtSpecies()
        let pokedexItem = NSMenuItem(title: "图鉴 (\(caught.count)/\(PokemonSpecies.allCases.count))", action: nil, keyEquivalent: "")
        let pokedexMenu = NSMenu()
        for species in caught {
            let isActive = species == currentPokemon
            let prefix = isActive ? "▶ " : "  "
            let item = NSMenuItem(title: "\(prefix)\(species.japaneseName) (\(species.displayName)) #\(species.dexNumber) \(species.rarity.stars)", action: #selector(selectPokemon(_:)), keyEquivalent: "")
            item.representedObject = species.rawValue
            pokedexMenu.addItem(item)
        }
        if caught.isEmpty {
            pokedexMenu.addItem(NSMenuItem(title: "还没有捕获宝可梦", action: nil, keyEquivalent: ""))
        }
        pokedexItem.submenu = pokedexMenu
        menu.addItem(pokedexItem)
        menu.addItem(NSMenuItem.separator())

        // Capture info
        let points = sessionManager.capturePoints
        let pending = sessionManager.pendingCaptures
        menu.addItem(NSMenuItem(title: "积分: \(points)/100", action: nil, keyEquivalent: ""))
        if pending > 0 {
            menu.addItem(NSMenuItem(title: "捕捉机会: \(pending) 🎰", action: #selector(triggerCapture), keyEquivalent: "c"))
        }
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "测试捕捉", action: #selector(triggerCapture), keyEquivalent: "t"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    private func setupNotchWindow() {
        // Find the screen with a notch (built-in display), not necessarily NSScreen.main
        var targetScreen: NSScreen?
        for screen in NSScreen.screens {
            logDebug("Screen: \(screen.localizedName) frame=\(screen.frame) safeArea=\(screen.safeAreaInsets)")
            let bounds = ScreenGeometry.notchBounds(for: screen)
            if bounds.width > 0 {
                targetScreen = screen
                logDebug("  -> Has notch! x=\(bounds.x), y=\(bounds.y), w=\(bounds.width), h=\(bounds.height)")
            }
        }

        guard let screen = targetScreen else {
            logDebug("No screen with notch found")
            return
        }

        let notchBounds = ScreenGeometry.notchBounds(for: screen)
        logDebug("Using screen: \(screen.localizedName), collapsed frame: \(notchBounds.collapsed)")

        notchWindow = NotchWindow(notchBounds: notchBounds, sessionManager: sessionManager, screen: screen, pokemon: currentPokemon)
        notchWindow?.orderFrontRegardless()
        logDebug("Notch window created and shown at frame: \(notchWindow?.frame ?? .zero)")
    }

    @objc private func selectPokemon(_ sender: NSMenuItem) {
        guard let rawValue = sender.representedObject as? String,
              let species = PokemonSpecies(rawValue: rawValue) else { return }
        currentPokemon = species
        PokemonStorage.setActive(species)
        logDebug("Selected: \(species.displayName)")
        setupStatusItem()
        setupNotchWindow()
    }

    @objc private func triggerCapture() {
        sessionManager.triggerCapture()
        setupStatusItem()  // refresh menu to show updated counts
    }

    private func startSocketServer() {
        socketServer = SocketServer(sessionManager: sessionManager)
        Task {
            await socketServer?.start()
        }
    }
}
