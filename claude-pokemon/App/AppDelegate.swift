import AppKit
import SwiftUI
import Combine

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

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var notchWindow: NotchWindow?
    private let sessionManager = SessionManager()
    private var socketServer: SocketServer?
    private var currentPokemon: PokemonSpecies = .pikachu
    private var appLanguage: AppLanguage = .current
    private var cancellables = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ notification: Notification) {
        currentPokemon = PokemonGacha.loadOrGenerate()
        PokemonStorage.addCaught(currentPokemon)  // ensure starter is in collection
        bindMenuRefresh()
        setupStatusItem()
        startSocketServer()

        // Delay window setup slightly to ensure screen APIs are fully available
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.setupNotchWindow()
        }
    }

    private func setupStatusItem() {
        let strings = AppStrings(language: appLanguage)

        if statusItem == nil {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        }
        if let button = statusItem.button {
            button.image = pokemonStatusBarImage(species: currentPokemon, size: 18)
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: strings.appTitle, action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())

        // Current Pokemon info
        let pokemonInfo = NSMenuItem(
            title: strings.currentPokemonTitle(currentPokemon),
            action: nil,
            keyEquivalent: ""
        )
        menu.addItem(pokemonInfo)
        let rarityInfo = NSMenuItem(title: strings.rarityTitle(currentPokemon.rarity), action: nil, keyEquivalent: "")
        menu.addItem(rarityInfo)
        menu.addItem(NSMenuItem.separator())

        // Pokedex submenu — only caught, in capture order
        let caught = PokemonStorage.caughtSpecies()
        let pokedexItem = NSMenuItem(
            title: strings.pokedexTitle(caught: caught.count, total: PokemonSpecies.allCases.count),
            action: nil,
            keyEquivalent: ""
        )
        let pokedexMenu = NSMenu()
        for species in caught {
            let isActive = species == currentPokemon
            let item = NSMenuItem(
                title: strings.pokedexEntryTitle(for: species, isActive: isActive),
                action: #selector(selectPokemon(_:)),
                keyEquivalent: ""
            )
            item.representedObject = species.rawValue
            item.target = self
            pokedexMenu.addItem(item)
        }
        if caught.isEmpty {
            pokedexMenu.addItem(NSMenuItem(title: strings.emptyPokedexTitle, action: nil, keyEquivalent: ""))
        }
        pokedexItem.submenu = pokedexMenu
        menu.addItem(pokedexItem)
        menu.addItem(NSMenuItem.separator())

        let languageItem = NSMenuItem(title: strings.languageMenuTitle, action: nil, keyEquivalent: "")
        let languageMenu = NSMenu()
        for language in AppLanguage.allCases {
            let item = NSMenuItem(
                title: language.menuDisplayName,
                action: #selector(selectLanguage(_:)),
                keyEquivalent: ""
            )
            item.representedObject = language.rawValue
            item.state = language == appLanguage ? .on : .off
            item.target = self
            languageMenu.addItem(item)
        }
        languageItem.submenu = languageMenu
        menu.addItem(languageItem)
        menu.addItem(NSMenuItem.separator())

        // Capture info
        let points = sessionManager.capturePoints
        let pending = sessionManager.pendingCaptures
        menu.addItem(NSMenuItem(title: strings.capturePointsTitle(points), action: nil, keyEquivalent: ""))
        if pending > 0 {
            let captureItem = NSMenuItem(
                title: strings.captureChanceTitle(pending),
                action: #selector(triggerCapture),
                keyEquivalent: "c"
            )
            captureItem.target = self
            menu.addItem(captureItem)
            menu.addItem(NSMenuItem.separator())
        }
        menu.addItem(NSMenuItem(title: strings.quitTitle, action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    private func bindMenuRefresh() {
        sessionManager.$capturePoints
            .combineLatest(sessionManager.$pendingCaptures)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _, _ in
                self?.setupStatusItem()
            }
            .store(in: &cancellables)
    }

    private func setupNotchWindow() {
        notchWindow?.close()
        notchWindow = nil

        // Find the screen with a notch (built-in display), not necessarily NSScreen.main
        var targetScreen: NSScreen?
        for screen in NSScreen.screens {
            let bounds = ScreenGeometry.notchBounds(for: screen)
            if bounds.width > 0 {
                targetScreen = screen
            }
        }

        guard let screen = targetScreen else {
            return
        }

        let notchBounds = ScreenGeometry.notchBounds(for: screen)

        notchWindow = NotchWindow(
            notchBounds: notchBounds,
            sessionManager: sessionManager,
            screen: screen,
            pokemon: currentPokemon,
            language: appLanguage
        )
        notchWindow?.orderFrontRegardless()
    }

    @objc private func selectPokemon(_ sender: NSMenuItem) {
        guard let rawValue = sender.representedObject as? String,
              let species = PokemonSpecies(rawValue: rawValue) else { return }
        currentPokemon = species
        PokemonStorage.setActive(species)
        setupStatusItem()
        setupNotchWindow()
    }

    @objc private func selectLanguage(_ sender: NSMenuItem) {
        guard let rawValue = sender.representedObject as? String,
              let language = AppLanguage(rawValue: rawValue) else { return }

        appLanguage = language
        AppLanguage.setCurrent(language)
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

    func applicationWillTerminate(_ notification: Notification) {
        cancellables.removeAll()
        notchWindow?.close()
        notchWindow = nil
    }
}
