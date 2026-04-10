import Foundation

extension Notification.Name {
    static let appLanguageDidChange = Notification.Name("appLanguageDidChange")
}

enum AppLanguage: String, CaseIterable {
    case chinese = "zh-Hans"
    case english = "en"

    static let userDefaultsKey = "appLanguage"

    static var current: AppLanguage {
        guard let rawValue = UserDefaults.standard.string(forKey: userDefaultsKey),
              let language = AppLanguage(rawValue: rawValue) else {
            return .chinese
        }
        return language
    }

    static func setCurrent(_ language: AppLanguage) {
        guard current != language else { return }
        UserDefaults.standard.set(language.rawValue, forKey: userDefaultsKey)
        NotificationCenter.default.post(name: .appLanguageDidChange, object: language)
    }

    var menuDisplayName: String {
        switch self {
        case .chinese:
            return "中文"
        case .english:
            return "English"
        }
    }
}

struct AppStrings {
    let language: AppLanguage

    var appTitle: String {
        switch language {
        case .chinese:
            return "Claude 宝可梦"
        case .english:
            return "Claude Pokemon"
        }
    }

    var languageMenuTitle: String {
        switch language {
        case .chinese:
            return "语言"
        case .english:
            return "Language"
        }
    }

    func currentPokemonTitle(_ species: PokemonSpecies) -> String {
        switch language {
        case .chinese:
            return "当前: \(species.localizedDisplayName(in: language)) #\(species.dexNumber)"
        case .english:
            return "Current: \(species.localizedDisplayName(in: language)) #\(species.dexNumber)"
        }
    }

    func rarityTitle(_ rarity: PokemonRarity) -> String {
        "\(rarity.localizedName(in: language)) \(rarity.stars)"
    }

    func pokedexTitle(caught: Int, total: Int) -> String {
        switch language {
        case .chinese:
            return "图鉴 (\(caught)/\(total))"
        case .english:
            return "Pokedex (\(caught)/\(total))"
        }
    }

    func pokedexEntryTitle(for species: PokemonSpecies, isActive: Bool) -> String {
        let prefix = isActive ? "▶ " : "  "
        return "\(prefix)\(species.localizedDisplayName(in: language)) #\(species.dexNumber) \(species.rarity.stars)"
    }

    var emptyPokedexTitle: String {
        switch language {
        case .chinese:
            return "还没有捕获宝可梦"
        case .english:
            return "No Pokemon caught yet"
        }
    }

    func capturePointsTitle(_ points: Int) -> String {
        switch language {
        case .chinese:
            return "积分: \(points)/100"
        case .english:
            return "Points: \(points)/100"
        }
    }

    func captureChanceTitle(_ pendingCaptures: Int) -> String {
        switch language {
        case .chinese:
            return "捕捉机会: \(pendingCaptures) 🎰"
        case .english:
            return "Capture Chance: \(pendingCaptures) 🎰"
        }
    }

    var quitTitle: String {
        switch language {
        case .chinese:
            return "退出"
        case .english:
            return "Quit"
        }
    }

    var allowTitle: String {
        switch language {
        case .chinese:
            return "允许"
        case .english:
            return "Allow"
        }
    }

    var denyTitle: String {
        switch language {
        case .chinese:
            return "拒绝"
        case .english:
            return "Deny"
        }
    }

    var captureNewPokemonTitle: String {
        switch language {
        case .chinese:
            return "捕获了新宝可梦!"
        case .english:
            return "Caught a New Pokemon!"
        }
    }

    var duplicatePokemonTitle: String {
        switch language {
        case .chinese:
            return "已拥有，积分 +20"
        case .english:
            return "Already caught, +20 points"
        }
    }

    var okTitle: String {
        switch language {
        case .chinese:
            return "确定"
        case .english:
            return "OK"
        }
    }
}

extension PokemonSpecies {
    func localizedDisplayName(in language: AppLanguage) -> String {
        switch language {
        case .chinese:
            return japaneseName
        case .english:
            return displayName
        }
    }
}

extension PokemonRarity {
    func localizedName(in language: AppLanguage) -> String {
        switch (language, self) {
        case (.chinese, .common):
            return "普通"
        case (.chinese, .uncommon):
            return "少见"
        case (.chinese, .rare):
            return "稀有"
        case (.chinese, .epic):
            return "史诗"
        case (.chinese, .legendary):
            return "传说"
        case (.english, .common):
            return "Common"
        case (.english, .uncommon):
            return "Uncommon"
        case (.english, .rare):
            return "Rare"
        case (.english, .epic):
            return "Epic"
        case (.english, .legendary):
            return "Legendary"
        }
    }
}
