import SwiftUI

// MARK: - Rarity

enum PokemonRarity: String, Codable, CaseIterable {
    case common = "Common"
    case uncommon = "Uncommon"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"

    var stars: String {
        switch self {
        case .common: return "⭐"; case .uncommon: return "⭐⭐"; case .rare: return "⭐⭐⭐"
        case .epic: return "⭐⭐⭐⭐"; case .legendary: return "⭐⭐⭐⭐⭐"
        }
    }
    var weight: Int {
        switch self {
        case .common: return 40; case .uncommon: return 30; case .rare: return 18
        case .epic: return 9; case .legendary: return 3
        }
    }
}

// MARK: - All 151 Pokemon from Pokemon Yellow

enum PokemonSpecies: String, Codable, CaseIterable {
    case bulbasaur, ivysaur, venusaur
    case charmander, charmeleon, charizard
    case squirtle, wartortle, blastoise
    case caterpie, metapod, butterfree
    case weedle, kakuna, beedrill
    case pidgey, pidgeotto, pidgeot
    case rattata, raticate
    case spearow, fearow
    case ekans, arbok
    case pikachu, raichu
    case sandshrew, sandslash
    case nidoranF, nidorina, nidoqueen
    case nidoranM, nidorino, nidoking
    case clefairy, clefable
    case vulpix, ninetales
    case jigglypuff, wigglytuff
    case zubat, golbat
    case oddish, gloom, vileplume
    case paras, parasect
    case venonat, venomoth
    case diglett, dugtrio
    case meowth, persian
    case psyduck, golduck
    case mankey, primeape
    case growlithe, arcanine
    case poliwag, poliwhirl, poliwrath
    case abra, kadabra, alakazam
    case machop, machoke, machamp
    case bellsprout, weepinbell, victreebel
    case tentacool, tentacruel
    case geodude, graveler, golem
    case ponyta, rapidash
    case slowpoke, slowbro
    case magnemite, magneton
    case farfetchd
    case doduo, dodrio
    case seel, dewgong
    case grimer, muk
    case shellder, cloyster
    case gastly, haunter, gengar
    case onix
    case drowzee, hypno
    case krabby, kingler
    case voltorb, electrode
    case exeggcute, exeggutor
    case cubone, marowak
    case hitmonlee, hitmonchan
    case lickitung
    case koffing, weezing
    case rhyhorn, rhydon
    case chansey
    case tangela
    case kangaskhan
    case horsea, seadra
    case goldeen, seaking
    case staryu, starmie
    case mrMime
    case scyther
    case jynx
    case electabuzz
    case magmar
    case pinsir
    case tauros
    case magikarp, gyarados
    case lapras
    case ditto
    case eevee, vaporeon, jolteon, flareon
    case porygon
    case omanyte, omastar
    case kabuto, kabutops
    case aerodactyl
    case snorlax
    case articuno, zapdos, moltres
    case dratini, dragonair, dragonite
    case mewtwo
    case mew

    // MARK: - Display Names
    var displayName: String {
        let names: [PokemonSpecies: String] = [
            .bulbasaur: "Bulbasaur", .ivysaur: "Ivysaur", .venusaur: "Venusaur",
            .charmander: "Charmander", .charmeleon: "Charmeleon", .charizard: "Charizard",
            .squirtle: "Squirtle", .wartortle: "Wartortle", .blastoise: "Blastoise",
            .caterpie: "Caterpie", .metapod: "Metapod", .butterfree: "Butterfree",
            .weedle: "Weedle", .kakuna: "Kakuna", .beedrill: "Beedrill",
            .pidgey: "Pidgey", .pidgeotto: "Pidgeotto", .pidgeot: "Pidgeot",
            .rattata: "Rattata", .raticate: "Raticate",
            .spearow: "Spearow", .fearow: "Fearow",
            .ekans: "Ekans", .arbok: "Arbok",
            .pikachu: "Pikachu", .raichu: "Raichu",
            .sandshrew: "Sandshrew", .sandslash: "Sandslash",
            .nidoranF: "Nidoran♀", .nidorina: "Nidorina", .nidoqueen: "Nidoqueen",
            .nidoranM: "Nidoran♂", .nidorino: "Nidorino", .nidoking: "Nidoking",
            .clefairy: "Clefairy", .clefable: "Clefable",
            .vulpix: "Vulpix", .ninetales: "Ninetales",
            .jigglypuff: "Jigglypuff", .wigglytuff: "Wigglytuff",
            .zubat: "Zubat", .golbat: "Golbat",
            .oddish: "Oddish", .gloom: "Gloom", .vileplume: "Vileplume",
            .paras: "Paras", .parasect: "Parasect",
            .venonat: "Venonat", .venomoth: "Venomoth",
            .diglett: "Diglett", .dugtrio: "Dugtrio",
            .meowth: "Meowth", .persian: "Persian",
            .psyduck: "Psyduck", .golduck: "Golduck",
            .mankey: "Mankey", .primeape: "Primeape",
            .growlithe: "Growlithe", .arcanine: "Arcanine",
            .poliwag: "Poliwag", .poliwhirl: "Poliwhirl", .poliwrath: "Poliwrath",
            .abra: "Abra", .kadabra: "Kadabra", .alakazam: "Alakazam",
            .machop: "Machop", .machoke: "Machoke", .machamp: "Machamp",
            .bellsprout: "Bellsprout", .weepinbell: "Weepinbell", .victreebel: "Victreebel",
            .tentacool: "Tentacool", .tentacruel: "Tentacruel",
            .geodude: "Geodude", .graveler: "Graveler", .golem: "Golem",
            .ponyta: "Ponyta", .rapidash: "Rapidash",
            .slowpoke: "Slowpoke", .slowbro: "Slowbro",
            .magnemite: "Magnemite", .magneton: "Magneton",
            .farfetchd: "Farfetch'd",
            .doduo: "Doduo", .dodrio: "Dodrio",
            .seel: "Seel", .dewgong: "Dewgong",
            .grimer: "Grimer", .muk: "Muk",
            .shellder: "Shellder", .cloyster: "Cloyster",
            .gastly: "Gastly", .haunter: "Haunter", .gengar: "Gengar",
            .onix: "Onix",
            .drowzee: "Drowzee", .hypno: "Hypno",
            .krabby: "Krabby", .kingler: "Kingler",
            .voltorb: "Voltorb", .electrode: "Electrode",
            .exeggcute: "Exeggcute", .exeggutor: "Exeggutor",
            .cubone: "Cubone", .marowak: "Marowak",
            .hitmonlee: "Hitmonlee", .hitmonchan: "Hitmonchan",
            .lickitung: "Lickitung",
            .koffing: "Koffing", .weezing: "Weezing",
            .rhyhorn: "Rhyhorn", .rhydon: "Rhydon",
            .chansey: "Chansey", .tangela: "Tangela", .kangaskhan: "Kangaskhan",
            .horsea: "Horsea", .seadra: "Seadra",
            .goldeen: "Goldeen", .seaking: "Seaking",
            .staryu: "Staryu", .starmie: "Starmie",
            .mrMime: "Mr. Mime",
            .scyther: "Scyther", .jynx: "Jynx",
            .electabuzz: "Electabuzz", .magmar: "Magmar",
            .pinsir: "Pinsir", .tauros: "Tauros",
            .magikarp: "Magikarp", .gyarados: "Gyarados",
            .lapras: "Lapras", .ditto: "Ditto",
            .eevee: "Eevee", .vaporeon: "Vaporeon", .jolteon: "Jolteon", .flareon: "Flareon",
            .porygon: "Porygon",
            .omanyte: "Omanyte", .omastar: "Omastar",
            .kabuto: "Kabuto", .kabutops: "Kabutops",
            .aerodactyl: "Aerodactyl", .snorlax: "Snorlax",
            .articuno: "Articuno", .zapdos: "Zapdos", .moltres: "Moltres",
            .dratini: "Dratini", .dragonair: "Dragonair", .dragonite: "Dragonite",
            .mewtwo: "Mewtwo", .mew: "Mew",
        ]
        return names[self] ?? rawValue.capitalized
    }

    var japaneseName: String {
        let names: [PokemonSpecies: String] = [
            .bulbasaur: "妙蛙种子", .ivysaur: "妙蛙草", .venusaur: "妙蛙花",
            .charmander: "小火龙", .charmeleon: "火恐龙", .charizard: "喷火龙",
            .squirtle: "杰尼龟", .wartortle: "卡咪龟", .blastoise: "水箭龟",
            .caterpie: "绿毛虫", .metapod: "铁甲蛹", .butterfree: "巴大蝶",
            .weedle: "独角虫", .kakuna: "铁壳蛹", .beedrill: "大针蜂",
            .pidgey: "波波", .pidgeotto: "比比鸟", .pidgeot: "大比鸟",
            .rattata: "小拉达", .raticate: "拉达",
            .spearow: "烈雀", .fearow: "大嘴雀",
            .ekans: "阿柏蛇", .arbok: "阿柏怪",
            .pikachu: "皮卡丘", .raichu: "雷丘",
            .sandshrew: "穿山鼠", .sandslash: "穿山王",
            .nidoranF: "尼多兰", .nidorina: "尼多娜", .nidoqueen: "尼多后",
            .nidoranM: "尼多朗", .nidorino: "尼多力诺", .nidoking: "尼多王",
            .clefairy: "皮皮", .clefable: "皮可西",
            .vulpix: "六尾", .ninetales: "九尾",
            .jigglypuff: "胖丁", .wigglytuff: "胖可丁",
            .zubat: "超音蝠", .golbat: "大嘴蝠",
            .oddish: "走路草", .gloom: "臭臭花", .vileplume: "霸王花",
            .paras: "派拉斯", .parasect: "派拉斯特",
            .venonat: "毛球", .venomoth: "摩鲁蛾",
            .diglett: "地鼠", .dugtrio: "三地鼠",
            .meowth: "喵喵", .persian: "猫老大",
            .psyduck: "可达鸭", .golduck: "哥达鸭",
            .mankey: "猴怪", .primeape: "火暴猴",
            .growlithe: "卡蒂狗", .arcanine: "风速狗",
            .poliwag: "蚊香蝌蚪", .poliwhirl: "蚊香君", .poliwrath: "蚊香泳士",
            .abra: "凯西", .kadabra: "勇基拉", .alakazam: "胡地",
            .machop: "腕力", .machoke: "豪力", .machamp: "怪力",
            .bellsprout: "喇叭芽", .weepinbell: "口呆花", .victreebel: "大食花",
            .tentacool: "玛瑙水母", .tentacruel: "毒刺水母",
            .geodude: "小拳石", .graveler: "隆隆石", .golem: "隆隆岩",
            .ponyta: "小火马", .rapidash: "烈焰马",
            .slowpoke: "呆呆兽", .slowbro: "呆壳兽",
            .magnemite: "小磁怪", .magneton: "三合一磁怪",
            .farfetchd: "大葱鸭",
            .doduo: "嘟嘟", .dodrio: "嘟嘟利",
            .seel: "小海狮", .dewgong: "白海狮",
            .grimer: "臭泥", .muk: "臭臭泥",
            .shellder: "大舌贝", .cloyster: "刺甲贝",
            .gastly: "鬼斯", .haunter: "鬼斯通", .gengar: "耿鬼",
            .onix: "大岩蛇",
            .drowzee: "催眠貘", .hypno: "引梦貘人",
            .krabby: "大钳蟹", .kingler: "巨钳蟹",
            .voltorb: "霹雳电球", .electrode: "顽皮雷弹",
            .exeggcute: "蛋蛋", .exeggutor: "椰蛋树",
            .cubone: "卡拉卡拉", .marowak: "嘎啦嘎啦",
            .hitmonlee: "飞腿郎", .hitmonchan: "快拳郎",
            .lickitung: "大舌头",
            .koffing: "瓦斯弹", .weezing: "双弹瓦斯",
            .rhyhorn: "独角犀牛", .rhydon: "钻角犀兽",
            .chansey: "吉利蛋", .tangela: "蔓藤怪", .kangaskhan: "袋兽",
            .horsea: "墨海马", .seadra: "海刺龙",
            .goldeen: "角金鱼", .seaking: "金鱼王",
            .staryu: "海星星", .starmie: "宝石海星",
            .mrMime: "魔墙人偶",
            .scyther: "飞天螳螂", .jynx: "迷唇姐",
            .electabuzz: "电击兽", .magmar: "鸭嘴火兽",
            .pinsir: "凯罗斯", .tauros: "肯泰罗",
            .magikarp: "鲤鱼王", .gyarados: "暴鲤龙",
            .lapras: "拉普拉斯", .ditto: "百变怪",
            .eevee: "伊布", .vaporeon: "水伊布", .jolteon: "雷伊布", .flareon: "火伊布",
            .porygon: "多边兽",
            .omanyte: "菊石兽", .omastar: "多刺菊石兽",
            .kabuto: "化石盔", .kabutops: "镰刀盔",
            .aerodactyl: "化石翼龙", .snorlax: "卡比兽",
            .articuno: "急冻鸟", .zapdos: "闪电鸟", .moltres: "火焰鸟",
            .dratini: "迷你龙", .dragonair: "哈克龙", .dragonite: "快龙",
            .mewtwo: "超梦", .mew: "梦幻",
        ]
        return names[self] ?? displayName
    }

    // MARK: - Rarity
    var rarity: PokemonRarity {
        switch self {
        // Common: basic wild Pokemon
        case .caterpie, .metapod, .weedle, .kakuna, .pidgey, .rattata, .spearow,
             .ekans, .sandshrew, .nidoranF, .nidoranM, .zubat, .oddish, .paras,
             .venonat, .diglett, .meowth, .psyduck, .mankey, .poliwag, .bellsprout,
             .tentacool, .geodude, .drowzee, .magikarp, .krabby, .voltorb, .goldeen,
             .staryu, .horsea, .grimer, .seel, .doduo, .magnemite, .exeggcute, .rhyhorn:
            return .common
        // Uncommon: starters, mid-evos, less common
        case .bulbasaur, .charmander, .squirtle, .pikachu, .eevee, .jigglypuff,
             .vulpix, .growlithe, .abra, .machop, .ponyta, .slowpoke, .shellder,
             .gastly, .cubone, .koffing, .clefairy,
             .ivysaur, .charmeleon, .wartortle, .pidgeotto, .raticate, .fearow,
             .arbok, .sandslash, .nidorina, .nidorino, .golbat, .gloom, .parasect,
             .venomoth, .dugtrio, .persian, .golduck, .primeape, .poliwhirl,
             .kadabra, .machoke, .weepinbell, .graveler, .rapidash, .slowbro,
             .magneton, .dodrio, .dewgong, .muk, .cloyster, .haunter, .hypno,
             .kingler, .electrode, .marowak, .weezing, .seadra, .seaking,
             .starmie, .farfetchd, .butterfree, .beedrill, .lickitung, .tangela,
             .onix, .raichu, .wigglytuff:
            return .uncommon
        // Rare: final evos, rare encounters
        case .venusaur, .charizard, .blastoise, .pidgeot, .nidoqueen, .nidoking,
             .clefable, .ninetales, .vileplume, .victreebel, .tentacruel, .golem,
             .poliwrath, .alakazam, .machamp, .exeggutor, .rhydon, .kangaskhan,
             .mrMime, .jynx, .electabuzz, .magmar, .vaporeon, .jolteon, .flareon,
             .snorlax, .lapras, .gengar, .gyarados, .ditto, .arcanine, .chansey,
             .scyther, .pinsir, .tauros, .hitmonlee, .hitmonchan:
            return .rare
        // Epic: fossils, pseudo-legendaries, legendary birds
        case .omanyte, .omastar, .kabuto, .kabutops, .aerodactyl, .porygon,
             .dratini, .dragonair, .dragonite, .articuno, .zapdos, .moltres:
            return .epic
        // Legendary
        case .mewtwo, .mew:
            return .legendary
        }
    }

    var dexNumber: Int {
        let numbers: [PokemonSpecies: Int] = [
            .bulbasaur: 1, .ivysaur: 2, .venusaur: 3,
            .charmander: 4, .charmeleon: 5, .charizard: 6,
            .squirtle: 7, .wartortle: 8, .blastoise: 9,
            .caterpie: 10, .metapod: 11, .butterfree: 12,
            .weedle: 13, .kakuna: 14, .beedrill: 15,
            .pidgey: 16, .pidgeotto: 17, .pidgeot: 18,
            .rattata: 19, .raticate: 20,
            .spearow: 21, .fearow: 22,
            .ekans: 23, .arbok: 24,
            .pikachu: 25, .raichu: 26,
            .sandshrew: 27, .sandslash: 28,
            .nidoranF: 29, .nidorina: 30, .nidoqueen: 31,
            .nidoranM: 32, .nidorino: 33, .nidoking: 34,
            .clefairy: 35, .clefable: 36,
            .vulpix: 37, .ninetales: 38,
            .jigglypuff: 39, .wigglytuff: 40,
            .zubat: 41, .golbat: 42,
            .oddish: 43, .gloom: 44, .vileplume: 45,
            .paras: 46, .parasect: 47,
            .venonat: 48, .venomoth: 49,
            .diglett: 50, .dugtrio: 51,
            .meowth: 52, .persian: 53,
            .psyduck: 54, .golduck: 55,
            .mankey: 56, .primeape: 57,
            .growlithe: 58, .arcanine: 59,
            .poliwag: 60, .poliwhirl: 61, .poliwrath: 62,
            .abra: 63, .kadabra: 64, .alakazam: 65,
            .machop: 66, .machoke: 67, .machamp: 68,
            .bellsprout: 69, .weepinbell: 70, .victreebel: 71,
            .tentacool: 72, .tentacruel: 73,
            .geodude: 74, .graveler: 75, .golem: 76,
            .ponyta: 77, .rapidash: 78,
            .slowpoke: 79, .slowbro: 80,
            .magnemite: 81, .magneton: 82,
            .farfetchd: 83,
            .doduo: 84, .dodrio: 85,
            .seel: 86, .dewgong: 87,
            .grimer: 88, .muk: 89,
            .shellder: 90, .cloyster: 91,
            .gastly: 92, .haunter: 93, .gengar: 94,
            .onix: 95,
            .drowzee: 96, .hypno: 97,
            .krabby: 98, .kingler: 99,
            .voltorb: 100, .electrode: 101,
            .exeggcute: 102, .exeggutor: 103,
            .cubone: 104, .marowak: 105,
            .hitmonlee: 106, .hitmonchan: 107,
            .lickitung: 108,
            .koffing: 109, .weezing: 110,
            .rhyhorn: 111, .rhydon: 112,
            .chansey: 113, .tangela: 114, .kangaskhan: 115,
            .horsea: 116, .seadra: 117,
            .goldeen: 118, .seaking: 119,
            .staryu: 120, .starmie: 121,
            .mrMime: 122, .scyther: 123, .jynx: 124,
            .electabuzz: 125, .magmar: 126,
            .pinsir: 127, .tauros: 128,
            .magikarp: 129, .gyarados: 130,
            .lapras: 131, .ditto: 132,
            .eevee: 133, .vaporeon: 134, .jolteon: 135, .flareon: 136,
            .porygon: 137,
            .omanyte: 138, .omastar: 139,
            .kabuto: 140, .kabutops: 141,
            .aerodactyl: 142, .snorlax: 143,
            .articuno: 144, .zapdos: 145, .moltres: 146,
            .dratini: 147, .dragonair: 148, .dragonite: 149,
            .mewtwo: 150, .mew: 151,
        ]
        return numbers[self] ?? 0
    }

    // MARK: - Pixel Art (8x8)
    // '.' transparent, '1' primary, '2' secondary, 'A' accent, 'B' eye, 'C' feature

    var pixelGrid: [String] {
        switch self {
        // #1-3 Bulbasaur line
        case .bulbasaur:  return ["...CC...","..CCC...", "..11111.",".1B1B11.",".111111.","..1111..","..1..1..",".1....1."]
        case .ivysaur:    return ["..CCC...",".CCCCC..", "..11111.",".1B1B11.",".111111.","..1111..","..1..1..",".1....1."]
        case .venusaur:   return [".CCCCC..", "CCCCCCC.","..11111.",".1B1B11.",".1111111","..11111.","..1..1..",".1....1."]
        // #4-6 Charmander line
        case .charmander: return ["..111...",".1B1B1..",".11111..","..111...",".11211..","..111...","..1.1...",".1..1.C."]
        case .charmeleon: return ["..111...",".1B1B1..",".11111..","..1111..",".112211.","..1111..","..1..1..",".1..1..C"]
        case .charizard:  return ["..111...","C1B1B1C.",".11111..","..1111..",".112211.","..1111..","..1..1..",".1....1."]
        // #7-9 Squirtle line
        case .squirtle:   return ["..111...",".1B1B1..",".11111..","..222...",".21112..","..111...","..1.1...",".1...1.."]
        case .wartortle:  return ["..111...",".1B1B1..",".11111..","..222...",".21112..","..111...","..1.1...",".1..CC.."]
        case .blastoise:  return ["..111...","C1B1B1C.",".11111..","..222...",".21112..","..111...","..1..1..",".1....1."]
        // #10-12 Caterpie line
        case .caterpie:   return ["..C.....", "..111...",".1B1B1..","..111...",".11111..","..111...",".11111..","..222..."]
        case .metapod:    return ["........","..1111..",".111111.",".111111.",".1C11C1.",".111111.","..1111..","........"]
        case .butterfree: return ["CC....CC",".C1..1C.","..1111..",".1B11B1.","..1111..","..1111..","...11...","........"]
        // #13-15 Weedle line
        case .weedle:     return ["...C....", "..111...",".1B1B1..","..111...",".12121..","..111...",".12121..","..111..."]
        case .kakuna:     return ["........","..1111..",".1C111C.",".111111.",".111111.",".1C111C.","..1111..","........"]
        case .beedrill:   return ["C......C","..111...",".1B1B1..",".111111.","..1111..","..1111..",".1.11.1.","........"]
        // #16-18 Pidgey line
        case .pidgey:     return ["...11...","..111...",".1B1B1..",".11111..","..2C2...","..111...","..111...","..1.1..."]
        case .pidgeotto:  return ["..CC1...","..111...",".1B1B1..",".111111.","..2C2...","..1111..","..1..1..",".1....1."]
        case .pidgeot:    return [".CCC1...","..111...",".1B1B1..","11111111","..2C2...","..1111..","..1..1..",".1....1."]
        // #19-20 Rattata line
        case .rattata:    return [".C...C..",".11.11..","..1111..",".1B1B1..",".111111.","..1111..","...11...","..1..1.."]
        case .raticate:   return [".C...C..",".11.11..","..1111..",".1B1B1..",".1AA111.","..1111..","..1..1..",".1....1."]
        // #21-22 Spearow line
        case .spearow:    return ["...C1...", "..111...",".1B1B1..",".11111..","..1C1...","..111...","..1.1...",".1...1.."]
        case .fearow:     return ["...CC1..","..111...",".1B1B1..","11111111","..1C1...","..1111..","..1..1..",".1....1."]
        // #23-24 Ekans line
        case .ekans:      return ["..11....","..B1....",".1111...","..1111..", "...1111.","..1111..",".1111...",".111...."]
        case .arbok:      return [".C11C...",".1111...",".1B1B1..",".111111.","..1111..","...111..","..111...","..11...."]
        // #25-26 Pikachu line
        case .pikachu:    return ["..A...A.","..1...1.","..11111.",".1B1B11.",".11C1C1.","..11111.","...111..","...1.1.."]
        case .raichu:     return ["..A...A.","..1...1.","..11111.",".1B1B11.",".11C1C1.","..11111.","...111..","...2.2.."]
        // #27-28 Sandshrew line
        case .sandshrew:  return ["..1111..",".111111.",".1B11B1.",".111111.","..2222..","..2222..","..1..1..",".1....1."]
        case .sandslash:  return ["..CCC...", "..1111..",".1B11B1.",".111111.","..2222..","C.2222.C","..1..1..",".1....1."]
        // #29-31 Nidoran♀ line
        case .nidoranF:   return ["..C.....", "..111...",".1B1B1..",".111111.","..1111..","..1111..","..1.1...",".1...1.."]
        case .nidorina:   return ["..C.....", "..111...",".1B1B1..",".1111111","..11111.","..1111..","..1..1..",".1....1."]
        case .nidoqueen:  return ["..C.....","..111...",".1B1B1..",".1111111","..22221.","..2222..","..1..1..",".1....1."]
        // #32-34 Nidoran♂ line
        case .nidoranM:   return [".....C..", "..111...",".1B1B1..",".111111.","..1111..","..1111..","..1.1...",".1...1.."]
        case .nidorino:   return ["....CC..", "..111...",".1B1B1..",".1111111","..11111.","..1111..","..1..1..",".1....1."]
        case .nidoking:   return ["....CC..","..111...",".1B1B1..",".1111111","..22221.","..2222..","..1..1..",".1....1."]
        // #35-36 Clefairy line
        case .clefairy:   return ["..C..C..","..1111..",".111111.",".1B11B1.",".111111.","..1111..","..1..1..",".1....1."]
        case .clefable:   return ["..C..C..","..1111..","11111111",".1B11B1.","11111111","..1111..","..1..1..",".1....1."]
        // #37-38 Vulpix line
        case .vulpix:     return [".C...C..",".11.11..","..1111..",".1B1B1..",".111111.","..1111..","..111...","..C.C..."]
        case .ninetales:  return [".C.C.C..",".11111..","..1111..",".1B1B1..",".1111111","..11111.","...111..","..C.C.C."]
        // #39-40 Jigglypuff line
        case .jigglypuff: return ["...CC...","..1111..",".111111.",".1B11B1.",".111111.",".111111.","..1111..","..1..1.."]
        case .wigglytuff: return ["...CC...",".111111.","11111111",".1B11B1.","11111111",".111111.","..1111..","..1..1.."]
        // #41-42 Zubat line
        case .zubat:      return ["C......C",".C1..1C.","..1111..",".1B11B1.","..1111..","..1221..","...11...","........"]
        case .golbat:     return ["C......C",".C1111C.","..1111..",".1B11B1.","..AAAA..","..1111..","...11...","........"]
        // #43-45 Oddish line
        case .oddish:     return ["..C.C.C.","..CCCCC.","..CCCCC.","..11111.",".1B11B1.",".111111.","..1111..","..1..1.."]
        case .gloom:      return [".CC.CC..", "..CCC...","..11111.",".1B11B1.",".111111.",".1AA11..","..1111..","..1..1.."]
        case .vileplume:  return ["CCCCCCC.",".CCCCC..","..11111.",".1B11B1.",".1111111","..11111.","..1..1..",".1....1."]
        // #46-47 Paras line
        case .paras:      return [".CC.CC..",".CC.CC..","..1111..",".1B1B1..",".111111.","..1111..",".1.11.1.","1....1.."]
        case .parasect:   return ["CCCCCC..","CCCCCC..","..1111..",".1B1B1..","..111111","..11111.","..1..1..",".1....1."]
        // #48-49 Venonat line
        case .venonat:    return ["..1111..",".1BB111.",".1BB111.",".111111.",".111111.","..1111..","..1..1..",".1....1."]
        case .venomoth:   return ["CC....CC",".C1..1C.","..1111..",".1BB1B1.","..1111..","..1111..","...11...","........"]
        // #50-51 Diglett line
        case .diglett:    return ["........","........","...C....","..111...",".1B1B1..",".111111.","22222222","22222222"]
        case .dugtrio:    return ["........","..C.C.C.","..1.1.1.",".111111.","1B1B1B11","11111111","22222222","22222222"]
        // #52-53 Meowth line
        case .meowth:     return ["..C..C..", "..1111..",".111111.",".1B11B1.",".111111.","..1A11..","..1..1..",".1....1."]
        case .persian:    return ["..C..C..","..1111..","11111111",".1B11B1.","..111A1.","..1111..","..1..1..",".1....1."]
        // #54-55 Psyduck line
        case .psyduck:    return ["..CCC...","..111...",".1B1B1..",".11111..","..111...",".11211..","..111...","..1.1..."]
        case .golduck:    return ["..CCC...","..111...",".1B1B1..",".111111.","..1111..",".111111.","..1..1..",".1....1."]
        // #56-57 Mankey line
        case .mankey:     return ["...C....","..111...",".1B1B1..",".111111.","..1111..",".111111.","..1..1..",".1....1."]
        case .primeape:   return ["..CCC...","..111...",".1B1B1..","11111111","..1111..","11111111","..1..1..",".1....1."]
        // #58-59 Growlithe line
        case .growlithe:  return ["..111...",".1B1B1..",".11111..","..111...",".12121..",".11111..","..1.1...",".1...1.."]
        case .arcanine:   return ["..CCC...","..111...",".1B1B1..",".11111..",".121121.",".111111.","..1..1..",".1....1."]
        // #60-62 Poliwag line
        case .poliwag:    return ["........","..1111..",".111111.",".1B1AB1.",".11AA11.","..1111..","...CC...","........"]
        case .poliwhirl:  return ["..1111..",".111111.",".1B1AB1.",".11AA11.",".1AAAA1.","..1111..","..1..1..",".1....1."]
        case .poliwrath:  return ["..1111..","11111111",".1B1AB1.",".11AA11.",".1AAAA1.","..1111..","..1..1..",".1....1."]
        // #63-65 Abra line
        case .abra:       return ["..1111..",".111111.",".1BB111.",".111111.","..111...","..1111..","..111...","..1.1..."]
        case .kadabra:    return ["..1111..",".111111.",".1B11B1.",".111111.","C.1111..","..1111..","..1..1..",".1....1."]
        case .alakazam:   return ["..1111..",".1B11B1.",".111111.","..1111..",".C1111C.","..1111..","..1..1..",".1....1."]
        // #66-68 Machop line
        case .machop:     return ["..CCC...","..111...",".1B1B1..",".111111.","..1111..",".111111.","..1..1..",".1....1."]
        case .machoke:    return ["..CCC...","..111...",".1B1B1..","11111111","..1111..","11111111","..1..1..",".1....1."]
        case .machamp:    return ["..111...",".1B1B1..",".111111.","11111111",".111111.","11111111","..1..1..",".1....1."]
        // #69-71 Bellsprout line
        case .bellsprout: return ["..CCC...","..111...",".1B1B1..",".111111.","...1....","..111...","...1....","..1.1..."]
        case .weepinbell: return ["..CCC...",".11111..",".1B1B1..",".111111.",".1CCCC1.","..1111..","...11...","........"]
        case .victreebel: return [".CCCCC..","..1111..",".1B1B1..","11111111",".1CCCC1.","..1111..","...11...","........"]
        // #72-73 Tentacool line
        case .tentacool:  return ["..1111..",".1C11C1.",".1B11B1.",".111111.","..1111..",".1.11.1.","1..11..1","...11..."]
        case .tentacruel: return ["..1111..","11C11C11",".1B11B1.","11111111","..1111..","1..11..1","...11...","........"]
        // #74-76 Geodude line
        case .geodude:    return ["..1111..",".111111.",".1B11B1.",".111111.","..1111..",".1....1.","11....11","........"]
        case .graveler:   return [".111111.","11111111","11B11B11","11111111",".111111.","..1..1..",".1....1.","........"]
        case .golem:      return ["..2222..","21111.2.","21B11B2.","21111.2.","..2222..","..1111..","..1..1..",".1....1."]
        // #77-78 Ponyta line
        case .ponyta:     return ["..CCC...","..CC1...","..111...",".1B1B1..",".111111.","..1111..","..1..1..","..1..1.."]
        case .rapidash:   return [".CCCCC..","..CCC1..","..111...",".1B1B1..","..111111","..11111.","..1..1..","..1..1.."]
        // #79-80 Slowpoke line
        case .slowpoke:   return ["........",".111111.","1B1111B1","11111111",".111111.","..1111..","..1..1..","..1..1.."]
        case .slowbro:    return ["........",".111111.","1B1111B1","11111111",".111111.","..1122..","..1122..","..1..1.."]
        // #81-82 Magnemite line
        case .magnemite:  return ["........","...C....","..111...",".1B111..","C11111C.",".11111..","..111...","........"]
        case .magneton:   return ["..C.C...","..111...","C1B111C.","..111...",".C111C..",".1B111..","C11111C.","..111..."]
        // #83 Farfetch'd
        case .farfetchd:  return ["......C.","..111.C.",".1B1B1C.",".11111..","..111...","..1111..","..1.1...",".1...1.."]
        // #84-85 Doduo line
        case .doduo:      return [".11.11..",".B1.B1..","..1.1...","..111...",".11111..","..111...","..1.1...",".1...1.."]
        case .dodrio:     return ["11.11.11","B1.B1.B1","..111...","..111...",".11111..","..111...","..1.1...",".1...1.."]
        // #86-87 Seel line
        case .seel:       return ["........","..1111..",".111111.","1B1111B1","11111111",".111111.","..11C1..","........"]
        case .dewgong:    return ["..1111..","..11111.",".1B111B1","11111111","111111C.",".111111.","..1111..","........"]
        // #88-89 Grimer line
        case .grimer:     return ["........","..1111..",".111111.",".1B11B1.",".111111.",".111111.","11111111","........"]
        case .muk:        return ["..1111..","11111111","1B1111B1","11111111","11111111","11111111","11111111","........"]
        // #90-91 Shellder line
        case .shellder:   return ["........","..2222..",".222222.","21111.2.","2.B1..2.","21111.2.",".222222.","..2222.."]
        case .cloyster:   return ["C2C22C2C","2.1111.2","21B11B12","2111111.","21B11B12","2.1111.2","C2C22C2C","........"]
        // #92-94 Gastly line
        case .gastly:     return ["..C..C..",".C1111C.","C111111C",".1B11B1.",".111111.","C111111C",".C1111C.","..C..C.."]
        case .haunter:    return ["C......C",".C1111..",".1B11B1.",".111111.","..1111..","C.1111.C","..C..C..","........"]
        case .gengar:     return [".C1..1C.","..1111..",".111111.",".1B11B1.",".1AAAA1.",".111111.","..1111..","..1..1.."]
        // #95 Onix
        case .onix:       return ["..111...","..1B1...",".11111..","..111...","...111..","..111...",".111....","..11...."]
        // #96-97 Drowzee line
        case .drowzee:    return ["..1111..",".111111.",".1B11B1.",".111111.","..2222..",".222222.","..2222..","..1..1.."]
        case .hypno:      return ["..1111..",".111111.",".1B11B1.",".111111.","..2222..","C222222.","..2222..","..1..1.."]
        // #98-99 Krabby line
        case .krabby:     return ["........","C......C",".C1111C.",".1B11B1.",".111111.","..1111..","..1..1..",".1....1."]
        case .kingler:    return ["C.......",".C.111.C","..1B11C.","..111111","..1111..","..1111..","..1..1..",".1....1."]
        // #100-101 Voltorb line
        case .voltorb:    return ["........","..1111..",".111111.",".11B111.",".222222.","..2222..","........","........"]
        case .electrode:  return ["........","..2222..",".222222.",".22B222.",".111111.","..1111..","........","........"]
        // #102-103 Exeggcute line
        case .exeggcute:  return ["........",".11.11..",".B1.B1..",".11.11..","..11.11.",".B1..B1.",".11..11.","........"]
        case .exeggutor:  return ["CCC.CCC.","1B11B1C.","1111B11.","..111...",".11111..","..111...","..111...","..1.1..."]
        // #104-105 Cubone line
        case .cubone:     return ["..2222..",".2B22B2.",".222222.","..1111..",".111111.","..1111..","..1..1..",".1....1."]
        case .marowak:    return ["..2222..",".2B22B2.",".222222.","..1111..","C111111C","..1111..","..1..1..",".1....1."]
        // #106-107 Hitmonlee/Hitmonchan
        case .hitmonlee:  return ["..111...",".1B1B1..","..111...","..111...",".11.11..","11...11.",".1....1.","........"]
        case .hitmonchan: return ["..111...",".1B1B1..","..111...","..111...","C1111.C.","..111...","..1.1...",".1...1.."]
        // #108 Lickitung
        case .lickitung:  return ["..111...",".1B1B1..",".111111.","..1111..","C111111.","..1111..","..1..1..",".1....1."]
        // #109-110 Koffing line
        case .koffing:    return ["..1111..",".111111.",".1B11B1.",".11AA11.",".111111.",".1C11C1.","..1111..","........"]
        case .weezing:    return ["..11.11.",".111.111","1B11.1B1","1AA1.1A1","1111.111",".11..11.","........","........"]
        // #111-112 Rhyhorn line
        case .rhyhorn:    return ["..C11...",".1B1B1..","..1111..","11111111",".111111.","..1111..","..1..1..",".1....1."]
        case .rhydon:     return ["...CC...","..111...",".1B1B1..","..111111","..11111.","..1111..","..1..1..",".1....1."]
        // #113 Chansey
        case .chansey:    return ["..111...",".1B1B1..",".11111..",".111111.",".11C111.",".111111.","..1111..","..1..1.."]
        // #114 Tangela
        case .tangela:    return ["CCCCCCCC","C111111C","C1B11B1C","C111111C","CCCCCCCC","..1111..","..1..1..",".1....1."]
        // #115 Kangaskhan
        case .kangaskhan: return ["..111...",".1B1B1..",".111111.","..1111..","..1221..","..1111..","..1..1..",".1....1."]
        // #116-117 Horsea line
        case .horsea:     return ["........","..111...","..1B1...",".11111..","..1111..","...11...","..11....","........"]
        case .seadra:     return ["..C.....","..111...","..1B1...","C11111C.","..1111..","...111..","..111...","........"]
        // #118-119 Goldeen line
        case .goldeen:    return ["........","..1111..",".111111.","C1B1111.",".111111C","..1111..","...22...","........"]
        case .seaking:    return ["..C.....","..1111..","C111111.","11B1111C","C111111.","..1111..","...22...","........"]
        // #120-121 Staryu line
        case .staryu:     return ["...1....","..111...",".11A11..","1111111.","..111...",".11111..",".1...1..","........"]
        case .starmie:    return ["...1....","..111...","C11A11C.","1111111.","C11A11C.",".11111..",".1...1..","........"]
        // #122 Mr. Mime
        case .mrMime:     return ["..111...",".1B1B1..",".111111.","..111...","C.111.C.","..111...","..1.1...",".1...1.."]
        // #123 Scyther
        case .scyther:    return ["..111...",".1B1B1..","..111...","C11111C.","..1111..","..1111..","..1..1..",".1....1."]
        // #124 Jynx
        case .jynx:       return ["..CCC...",".CCCCC..","..111...",".1B1B1..",".1AA11..","..2222..","..2222..","..2..2.."]
        // #125 Electabuzz
        case .electabuzz: return ["..C.C...","..111...",".1B1B1..",".111111.","..1111..","..1111..","..1..1..",".1....1."]
        // #126 Magmar
        case .magmar:     return ["..CCC...","..111...",".1B1B1..",".111111.","..111C..","..1111..","..1..1..",".1....1."]
        // #127 Pinsir
        case .pinsir:     return ["C1....1C",".C1..1C.","..1111..",".1B11B1.",".111111.","..1111..","..1..1..",".1....1."]
        // #128 Tauros
        case .tauros:     return ["C......C",".C1..1C.","..1111..",".1B11B1.",".111111.","..1111..","..1..1..",".1....1."]
        // #129-130 Magikarp line
        case .magikarp:   return ["........","..1111..",".111111.",".1B1111C",".111111C","..1111..","..2222..","........"]
        case .gyarados:   return ["..CCC...",".11111..",".1B1B1..",".1AAA1..","..111...","..111...","...111..","....11C."]
        // #131 Lapras
        case .lapras:     return ["..11....",".1B1....",".111....","..11111.",".111111.",".222222.",".111111.","........"]
        // #132 Ditto
        case .ditto:      return ["........","..1111..",".111111.",".1.11.1.",".111111.",".111111.","..1111..","........"]
        // #133-136 Eevee line
        case .eevee:      return [".C...C..",".11.11..","..1111..",".1B1B1..",".111111.","..2221..","...11...","..1..1.."]
        case .vaporeon:   return [".C...C..",".11.11..","..1111..",".1B1B1..",".111111.","..1111..","...111..","..1..1.."]
        case .jolteon:    return [".CC.CC..",".11.11..","..1111..",".1B1B1..",".111111.","..1111..","...11...","..1..1.."]
        case .flareon:    return [".C...C..",".11.11..","..1111..",".1B1B1..",".1CCC11.","..1111..","...11...","..1..1.."]
        // #137 Porygon
        case .porygon:    return ["..1111..",".111111.",".1B1111.",".111111.","..2222..",".221122.","..2222..","..1..1.."]
        // #138-139 Omanyte line
        case .omanyte:    return ["..2222..",".222222.",".2.22.2.","21111.2.","2.B1..2.","21111.2.",".222222.","........"]
        case .omastar:    return ["..2222..","C222222C",".2.22.2.","21111.2.","2.B1..2.","21111.2.",".222222.","..C..C.."]
        // #140-141 Kabuto line
        case .kabuto:     return ["........","..2222..",".222222.","2B2222B2","21111112",".111111.","........","........"]
        case .kabutops:   return ["..2222..",".222222.","2B2222B2","21111112",".111111.","C.1111.C","..1..1..",".1....1."]
        // #142 Aerodactyl
        case .aerodactyl: return ["........","..111...",".1B1B1..",".1AA11..","C111111C","..1111..","..1..1..","........"]
        // #143 Snorlax
        case .snorlax:    return ["..1111..",".111111.",".1BB111.",".111111.",".222222.",".211112.",".222222.","..1..1.."]
        // #144-146 Legendary birds
        case .articuno:   return ["...CC...","...11...","..1111..",".1B11B1.","C111111C",".111111.","..1111..","...11..."]
        case .zapdos:     return ["...CC...","...11...","..1111..",".1B11B1.","C111111C",".111111.","..1111..","...11..."]
        case .moltres:    return ["..CCC...","...11...","..1111..",".1B11B1.","A111111A",".111111.","..1111..","...11..."]
        // #147-149 Dratini line
        case .dratini:    return ["........","..111...","..1B1...",".11111..","..1111..","...11...","..11....","..1....."]
        case .dragonair:  return ["...C....","..111...",".1B1B1..","..111...","..111...","...11...","..11....",".11....."]
        case .dragonite:  return ["..C..C..","..111...",".1B1B1..",".111111.","C11221C.","..1111..","..1..1..",".1....1."]
        // #150-151
        case .mewtwo:     return ["..C.C...","..111...",".11111..",".1B1B1..","..111...","..111...",".11.11..",".1...1.."]
        case .mew:        return ["....C...","..111...",".11111..",".1B1B1..",".11111..","..111...","..11....","..1....."]
        }
    }

    var palette: [Character: (r: Double, g: Double, b: Double)] {
        switch self {
        // Bulbasaur family - teal/green
        case .bulbasaur, .ivysaur: return ["1":(0.45,0.75,0.65),"2":(0.35,0.60,0.50),"B":(0.75,0.15,0.15),"C":(0.30,0.70,0.35)]
        case .venusaur: return ["1":(0.40,0.70,0.60),"2":(0.35,0.60,0.50),"B":(0.75,0.15,0.15),"C":(0.85,0.30,0.35)]
        // Charmander family - orange/red
        case .charmander: return ["1":(0.95,0.55,0.25),"2":(0.95,0.85,0.55),"B":(0.12,0.12,0.15),"C":(0.95,0.40,0.15)]
        case .charmeleon: return ["1":(0.90,0.40,0.25),"2":(0.90,0.80,0.50),"B":(0.12,0.12,0.15),"C":(0.95,0.40,0.15)]
        case .charizard: return ["1":(0.90,0.50,0.20),"2":(0.90,0.80,0.50),"B":(0.12,0.12,0.15),"C":(0.40,0.70,0.65)]
        // Squirtle family - blue
        case .squirtle: return ["1":(0.50,0.75,0.90),"2":(0.60,0.45,0.25),"B":(0.12,0.12,0.15),"C":(0.50,0.75,0.90)]
        case .wartortle: return ["1":(0.45,0.65,0.85),"2":(0.55,0.40,0.25),"B":(0.12,0.12,0.15),"C":(0.70,0.75,0.85)]
        case .blastoise: return ["1":(0.40,0.60,0.80),"2":(0.55,0.40,0.25),"B":(0.12,0.12,0.15),"C":(0.50,0.50,0.55)]
        // Caterpie family - green
        case .caterpie: return ["1":(0.45,0.80,0.40),"2":(0.85,0.65,0.35),"B":(0.12,0.12,0.15),"C":(0.90,0.30,0.25)]
        case .metapod: return ["1":(0.45,0.75,0.35),"2":(0.45,0.75,0.35),"B":(0.12,0.12,0.15),"C":(0.35,0.60,0.30)]
        case .butterfree: return ["1":(0.85,0.85,0.90),"2":(0.85,0.85,0.90),"B":(0.12,0.12,0.15),"C":(0.30,0.30,0.55)]
        // Weedle family - tan/yellow
        case .weedle: return ["1":(0.80,0.65,0.35),"2":(0.90,0.55,0.50),"B":(0.12,0.12,0.15),"C":(0.85,0.75,0.55)]
        case .kakuna: return ["1":(0.85,0.80,0.30),"2":(0.85,0.80,0.30),"B":(0.12,0.12,0.15),"C":(0.70,0.65,0.25)]
        case .beedrill: return ["1":(0.90,0.85,0.30),"2":(0.15,0.15,0.15),"B":(0.75,0.15,0.15),"C":(0.85,0.85,0.80)]
        // Pidgey family - brown
        case .pidgey: return ["1":(0.65,0.50,0.35),"2":(0.85,0.75,0.60),"B":(0.12,0.12,0.15),"C":(0.90,0.65,0.40)]
        case .pidgeotto: return ["1":(0.60,0.45,0.30),"2":(0.85,0.75,0.60),"B":(0.12,0.12,0.15),"C":(0.85,0.40,0.30)]
        case .pidgeot: return ["1":(0.60,0.45,0.30),"2":(0.85,0.75,0.60),"B":(0.12,0.12,0.15),"C":(0.90,0.75,0.30)]
        // Rattata family - purple
        case .rattata: return ["1":(0.60,0.45,0.65),"2":(0.85,0.80,0.75),"B":(0.75,0.15,0.15),"C":(0.75,0.55,0.80)]
        case .raticate: return ["1":(0.70,0.55,0.45),"2":(0.70,0.55,0.45),"A":(0.90,0.90,0.85),"B":(0.12,0.12,0.15),"C":(0.70,0.55,0.45)]
        // Spearow family - brown/red
        case .spearow: return ["1":(0.65,0.45,0.30),"2":(0.65,0.45,0.30),"B":(0.12,0.12,0.15),"C":(0.80,0.30,0.25)]
        case .fearow: return ["1":(0.60,0.45,0.30),"2":(0.60,0.45,0.30),"B":(0.12,0.12,0.15),"C":(0.85,0.35,0.30)]
        // Ekans family - purple
        case .ekans: return ["1":(0.55,0.40,0.60),"2":(0.55,0.40,0.60),"B":(0.12,0.12,0.15),"C":(0.55,0.40,0.60)]
        case .arbok: return ["1":(0.50,0.35,0.55),"2":(0.50,0.35,0.55),"B":(0.12,0.12,0.15),"C":(0.80,0.30,0.30)]
        // Pikachu family - yellow
        case .pikachu: return ["1":(0.98,0.85,0.25),"A":(0.15,0.15,0.15),"B":(0.12,0.12,0.15),"C":(0.90,0.30,0.25)]
        case .raichu: return ["1":(0.90,0.65,0.20),"2":(0.85,0.55,0.15),"A":(0.15,0.15,0.15),"B":(0.12,0.12,0.15),"C":(0.90,0.30,0.25)]
        // Sandshrew family - yellow/brown
        case .sandshrew: return ["1":(0.85,0.75,0.40),"2":(0.70,0.60,0.30),"B":(0.12,0.12,0.15),"C":(0.85,0.75,0.40)]
        case .sandslash: return ["1":(0.80,0.65,0.35),"2":(0.65,0.55,0.25),"B":(0.12,0.12,0.15),"C":(0.60,0.50,0.30)]
        // Nidoran♀ family - blue
        case .nidoranF, .nidorina: return ["1":(0.50,0.60,0.75),"2":(0.50,0.60,0.75),"B":(0.75,0.15,0.15),"C":(0.40,0.50,0.65)]
        case .nidoqueen: return ["1":(0.40,0.55,0.70),"2":(0.70,0.65,0.55),"B":(0.75,0.15,0.15),"C":(0.35,0.45,0.60)]
        // Nidoran♂ family - purple
        case .nidoranM, .nidorino: return ["1":(0.65,0.45,0.70),"2":(0.65,0.45,0.70),"B":(0.12,0.12,0.15),"C":(0.55,0.35,0.60)]
        case .nidoking: return ["1":(0.55,0.40,0.65),"2":(0.75,0.70,0.60),"B":(0.12,0.12,0.15),"C":(0.45,0.30,0.55)]
        // Clefairy family - pink
        case .clefairy, .clefable: return ["1":(0.95,0.72,0.75),"2":(0.95,0.72,0.75),"B":(0.12,0.12,0.15),"C":(0.70,0.50,0.50)]
        // Vulpix family - red/gold
        case .vulpix: return ["1":(0.80,0.40,0.25),"2":(0.80,0.40,0.25),"B":(0.12,0.12,0.15),"C":(0.90,0.55,0.30)]
        case .ninetales: return ["1":(0.90,0.82,0.55),"2":(0.90,0.82,0.55),"B":(0.75,0.15,0.15),"C":(0.85,0.75,0.45)]
        // Jigglypuff family - pink
        case .jigglypuff: return ["1":(0.95,0.70,0.75),"2":(0.95,0.70,0.75),"B":(0.25,0.55,0.65),"C":(0.85,0.55,0.60)]
        case .wigglytuff: return ["1":(0.95,0.68,0.72),"2":(0.95,0.68,0.72),"B":(0.25,0.55,0.65),"C":(0.85,0.55,0.60)]
        // Zubat family - blue-purple
        case .zubat: return ["1":(0.45,0.45,0.75),"2":(0.55,0.55,0.85),"B":(0.12,0.12,0.15),"C":(0.55,0.50,0.85)]
        case .golbat: return ["1":(0.45,0.45,0.75),"2":(0.45,0.45,0.75),"A":(0.85,0.30,0.30),"B":(0.12,0.12,0.15),"C":(0.55,0.50,0.85)]
        // Oddish family - blue/green
        case .oddish: return ["1":(0.35,0.45,0.75),"2":(0.35,0.45,0.75),"B":(0.75,0.15,0.15),"C":(0.35,0.70,0.35)]
        case .gloom: return ["1":(0.35,0.45,0.75),"2":(0.35,0.45,0.75),"A":(0.85,0.30,0.30),"B":(0.12,0.12,0.15),"C":(0.75,0.30,0.30)]
        case .vileplume: return ["1":(0.35,0.45,0.75),"2":(0.35,0.45,0.75),"B":(0.12,0.12,0.15),"C":(0.80,0.25,0.30)]
        // Paras family - orange/red
        case .paras: return ["1":(0.85,0.60,0.35),"2":(0.85,0.60,0.35),"B":(0.12,0.12,0.15),"C":(0.85,0.30,0.25)]
        case .parasect: return ["1":(0.85,0.55,0.30),"2":(0.85,0.55,0.30),"B":(0.12,0.12,0.15),"C":(0.80,0.25,0.20)]
        // Venonat family - purple
        case .venonat: return ["1":(0.55,0.35,0.60),"2":(0.55,0.35,0.60),"B":(0.80,0.25,0.25),"C":(0.55,0.35,0.60)]
        case .venomoth: return ["1":(0.70,0.60,0.80),"2":(0.70,0.60,0.80),"B":(0.50,0.60,0.80),"C":(0.85,0.80,0.90)]
        // Diglett family - brown
        case .diglett: return ["1":(0.65,0.45,0.30),"2":(0.55,0.40,0.25),"B":(0.12,0.12,0.15),"C":(0.90,0.60,0.55)]
        case .dugtrio: return ["1":(0.65,0.45,0.30),"2":(0.55,0.40,0.25),"B":(0.12,0.12,0.15),"C":(0.90,0.60,0.55)]
        // Meowth family - cream
        case .meowth: return ["1":(0.90,0.85,0.70),"2":(0.90,0.85,0.70),"A":(0.90,0.80,0.30),"B":(0.12,0.12,0.15),"C":(0.75,0.65,0.50)]
        case .persian: return ["1":(0.90,0.85,0.75),"2":(0.90,0.85,0.75),"A":(0.85,0.30,0.30),"B":(0.12,0.12,0.15),"C":(0.80,0.75,0.60)]
        // Psyduck family - yellow
        case .psyduck: return ["1":(0.95,0.82,0.30),"2":(0.85,0.75,0.55),"B":(0.12,0.12,0.15),"C":(0.15,0.15,0.15)]
        case .golduck: return ["1":(0.40,0.55,0.80),"2":(0.40,0.55,0.80),"B":(0.12,0.12,0.15),"C":(0.85,0.30,0.30)]
        // Mankey family - tan
        case .mankey: return ["1":(0.85,0.78,0.65),"2":(0.85,0.78,0.65),"B":(0.12,0.12,0.15),"C":(0.70,0.55,0.45)]
        case .primeape: return ["1":(0.85,0.78,0.65),"2":(0.85,0.78,0.65),"B":(0.12,0.12,0.15),"C":(0.65,0.50,0.40)]
        // Growlithe family - orange
        case .growlithe: return ["1":(0.90,0.55,0.25),"2":(0.85,0.80,0.60),"B":(0.12,0.12,0.15),"C":(0.90,0.55,0.25)]
        case .arcanine: return ["1":(0.90,0.60,0.25),"2":(0.90,0.85,0.65),"B":(0.12,0.12,0.15),"C":(0.85,0.78,0.55)]
        // Poliwag family - blue
        case .poliwag: return ["1":(0.40,0.55,0.80),"2":(0.40,0.55,0.80),"A":(0.15,0.15,0.20),"B":(0.12,0.12,0.15),"C":(0.85,0.85,0.90)]
        case .poliwhirl: return ["1":(0.40,0.55,0.80),"2":(0.40,0.55,0.80),"A":(0.15,0.15,0.20),"B":(0.12,0.12,0.15),"C":(0.40,0.55,0.80)]
        case .poliwrath: return ["1":(0.35,0.50,0.75),"2":(0.35,0.50,0.75),"A":(0.15,0.15,0.20),"B":(0.12,0.12,0.15),"C":(0.35,0.50,0.75)]
        // Abra family - yellow
        case .abra: return ["1":(0.85,0.72,0.30),"2":(0.85,0.72,0.30),"B":(0.12,0.12,0.15),"C":(0.85,0.72,0.30)]
        case .kadabra: return ["1":(0.85,0.72,0.30),"2":(0.85,0.72,0.30),"B":(0.12,0.12,0.15),"C":(0.60,0.50,0.30)]
        case .alakazam: return ["1":(0.85,0.72,0.30),"2":(0.85,0.72,0.30),"B":(0.12,0.12,0.15),"C":(0.60,0.50,0.30)]
        // Machop family - gray-blue
        case .machop: return ["1":(0.55,0.65,0.75),"2":(0.55,0.65,0.75),"B":(0.12,0.12,0.15),"C":(0.45,0.50,0.55)]
        case .machoke: return ["1":(0.50,0.60,0.70),"2":(0.50,0.60,0.70),"B":(0.12,0.12,0.15),"C":(0.45,0.50,0.55)]
        case .machamp: return ["1":(0.55,0.60,0.75),"2":(0.55,0.60,0.75),"B":(0.12,0.12,0.15),"C":(0.55,0.60,0.75)]
        // Bellsprout family - yellow/green
        case .bellsprout: return ["1":(0.90,0.85,0.30),"2":(0.90,0.85,0.30),"B":(0.12,0.12,0.15),"C":(0.40,0.70,0.35)]
        case .weepinbell: return ["1":(0.90,0.85,0.30),"2":(0.90,0.85,0.30),"B":(0.12,0.12,0.15),"C":(0.40,0.70,0.35)]
        case .victreebel: return ["1":(0.90,0.85,0.30),"2":(0.90,0.85,0.30),"B":(0.12,0.12,0.15),"C":(0.35,0.65,0.30)]
        // Tentacool family - blue
        case .tentacool: return ["1":(0.40,0.60,0.85),"2":(0.40,0.60,0.85),"B":(0.12,0.12,0.15),"C":(0.85,0.30,0.30)]
        case .tentacruel: return ["1":(0.35,0.55,0.80),"2":(0.35,0.55,0.80),"B":(0.12,0.12,0.15),"C":(0.85,0.30,0.30)]
        // Geodude family - gray
        case .geodude, .graveler: return ["1":(0.60,0.55,0.45),"2":(0.60,0.55,0.45),"B":(0.12,0.12,0.15),"C":(0.60,0.55,0.45)]
        case .golem: return ["1":(0.65,0.55,0.40),"2":(0.50,0.45,0.40),"B":(0.12,0.12,0.15),"C":(0.65,0.55,0.40)]
        // Ponyta family - cream/fire
        case .ponyta: return ["1":(0.90,0.80,0.60),"2":(0.90,0.80,0.60),"B":(0.12,0.12,0.15),"C":(0.95,0.45,0.20)]
        case .rapidash: return ["1":(0.90,0.80,0.60),"2":(0.90,0.80,0.60),"B":(0.12,0.12,0.15),"C":(0.95,0.40,0.15)]
        // Slowpoke family - pink
        case .slowpoke: return ["1":(0.90,0.65,0.70),"2":(0.90,0.65,0.70),"B":(0.12,0.12,0.15),"C":(0.90,0.65,0.70)]
        case .slowbro: return ["1":(0.90,0.65,0.70),"2":(0.55,0.50,0.55),"B":(0.12,0.12,0.15),"C":(0.90,0.65,0.70)]
        // Magnemite family - steel
        case .magnemite, .magneton: return ["1":(0.70,0.72,0.75),"2":(0.70,0.72,0.75),"B":(0.12,0.12,0.15),"C":(0.55,0.55,0.60)]
        // Farfetch'd
        case .farfetchd: return ["1":(0.70,0.55,0.35),"2":(0.70,0.55,0.35),"B":(0.12,0.12,0.15),"C":(0.40,0.65,0.30)]
        // Doduo family - brown
        case .doduo, .dodrio: return ["1":(0.65,0.50,0.30),"2":(0.65,0.50,0.30),"B":(0.12,0.12,0.15),"C":(0.65,0.50,0.30)]
        // Seel family - white
        case .seel: return ["1":(0.85,0.88,0.92),"2":(0.85,0.88,0.92),"B":(0.12,0.12,0.15),"C":(0.80,0.82,0.85)]
        case .dewgong: return ["1":(0.90,0.92,0.95),"2":(0.90,0.92,0.95),"B":(0.12,0.12,0.15),"C":(0.85,0.87,0.90)]
        // Grimer family - purple slime
        case .grimer, .muk: return ["1":(0.55,0.35,0.60),"2":(0.55,0.35,0.60),"B":(0.85,0.85,0.85),"C":(0.55,0.35,0.60)]
        // Shellder family - purple shell
        case .shellder: return ["1":(0.75,0.65,0.70),"2":(0.55,0.45,0.65),"B":(0.12,0.12,0.15),"C":(0.55,0.45,0.65)]
        case .cloyster: return ["1":(0.75,0.65,0.70),"2":(0.45,0.40,0.55),"B":(0.12,0.12,0.15),"C":(0.35,0.30,0.50)]
        // Gastly family - purple/dark
        case .gastly: return ["1":(0.30,0.25,0.35),"2":(0.30,0.25,0.35),"B":(0.90,0.90,0.90),"C":(0.45,0.35,0.55)]
        case .haunter: return ["1":(0.40,0.30,0.50),"2":(0.40,0.30,0.50),"B":(0.90,0.90,0.90),"C":(0.40,0.30,0.50)]
        case .gengar: return ["1":(0.45,0.30,0.55),"A":(0.90,0.30,0.30),"B":(0.90,0.90,0.90),"C":(0.55,0.35,0.65)]
        // Onix - gray
        case .onix: return ["1":(0.60,0.58,0.55),"2":(0.60,0.58,0.55),"B":(0.12,0.12,0.15),"C":(0.60,0.58,0.55)]
        // Drowzee family - yellow/brown
        case .drowzee: return ["1":(0.80,0.65,0.35),"2":(0.60,0.45,0.30),"B":(0.12,0.12,0.15),"C":(0.80,0.65,0.35)]
        case .hypno: return ["1":(0.85,0.72,0.35),"2":(0.65,0.50,0.30),"B":(0.12,0.12,0.15),"C":(0.70,0.65,0.60)]
        // Krabby family - orange
        case .krabby, .kingler: return ["1":(0.90,0.50,0.30),"2":(0.90,0.50,0.30),"B":(0.12,0.12,0.15),"C":(0.90,0.50,0.30)]
        // Voltorb family - red/white
        case .voltorb: return ["1":(0.85,0.25,0.25),"2":(0.90,0.90,0.90),"B":(0.12,0.12,0.15),"C":(0.85,0.25,0.25)]
        case .electrode: return ["1":(0.85,0.25,0.25),"2":(0.90,0.90,0.90),"B":(0.12,0.12,0.15),"C":(0.90,0.90,0.90)]
        // Exeggcute family
        case .exeggcute: return ["1":(0.90,0.82,0.70),"2":(0.90,0.82,0.70),"B":(0.12,0.12,0.15),"C":(0.90,0.82,0.70)]
        case .exeggutor: return ["1":(0.65,0.50,0.30),"2":(0.65,0.50,0.30),"B":(0.12,0.12,0.15),"C":(0.35,0.70,0.35)]
        // Cubone family - brown
        case .cubone, .marowak: return ["1":(0.70,0.55,0.35),"2":(0.85,0.82,0.75),"B":(0.12,0.12,0.15),"C":(0.70,0.55,0.35)]
        // Hitmonlee/Hitmonchan - brown/tan
        case .hitmonlee: return ["1":(0.70,0.55,0.40),"2":(0.70,0.55,0.40),"B":(0.12,0.12,0.15),"C":(0.70,0.55,0.40)]
        case .hitmonchan: return ["1":(0.70,0.55,0.40),"2":(0.70,0.55,0.40),"B":(0.12,0.12,0.15),"C":(0.85,0.30,0.30)]
        // Lickitung - pink
        case .lickitung: return ["1":(0.90,0.65,0.70),"2":(0.90,0.65,0.70),"B":(0.12,0.12,0.15),"C":(0.85,0.45,0.50)]
        // Koffing family - purple
        case .koffing: return ["1":(0.55,0.45,0.65),"2":(0.55,0.45,0.65),"A":(0.85,0.82,0.75),"B":(0.12,0.12,0.15),"C":(0.45,0.55,0.45)]
        case .weezing: return ["1":(0.55,0.45,0.65),"2":(0.55,0.45,0.65),"A":(0.85,0.82,0.75),"B":(0.12,0.12,0.15),"C":(0.55,0.45,0.65)]
        // Rhyhorn family - gray
        case .rhyhorn: return ["1":(0.60,0.58,0.55),"2":(0.60,0.58,0.55),"B":(0.12,0.12,0.15),"C":(0.50,0.48,0.45)]
        case .rhydon: return ["1":(0.55,0.53,0.50),"2":(0.55,0.53,0.50),"B":(0.12,0.12,0.15),"C":(0.45,0.43,0.40)]
        // Chansey - pink
        case .chansey: return ["1":(0.95,0.70,0.72),"2":(0.95,0.70,0.72),"B":(0.12,0.12,0.15),"C":(0.90,0.90,0.85)]
        // Tangela - blue vines
        case .tangela: return ["1":(0.40,0.55,0.80),"2":(0.40,0.55,0.80),"B":(0.12,0.12,0.15),"C":(0.35,0.50,0.75)]
        // Kangaskhan - brown
        case .kangaskhan: return ["1":(0.65,0.55,0.40),"2":(0.80,0.75,0.60),"B":(0.12,0.12,0.15),"C":(0.65,0.55,0.40)]
        // Horsea family - blue
        case .horsea, .seadra: return ["1":(0.40,0.55,0.85),"2":(0.40,0.55,0.85),"B":(0.12,0.12,0.15),"C":(0.45,0.60,0.90)]
        // Goldeen family - orange/white
        case .goldeen, .seaking: return ["1":(0.90,0.55,0.35),"2":(0.90,0.90,0.90),"B":(0.12,0.12,0.15),"C":(0.90,0.55,0.35)]
        // Staryu family - brown/purple
        case .staryu: return ["1":(0.70,0.55,0.35),"2":(0.70,0.55,0.35),"A":(0.85,0.30,0.30),"B":(0.12,0.12,0.15),"C":(0.70,0.55,0.35)]
        case .starmie: return ["1":(0.55,0.45,0.70),"2":(0.55,0.45,0.70),"A":(0.85,0.30,0.30),"B":(0.12,0.12,0.15),"C":(0.85,0.30,0.30)]
        // Mr. Mime - pink
        case .mrMime: return ["1":(0.90,0.70,0.72),"2":(0.90,0.70,0.72),"B":(0.12,0.12,0.15),"C":(0.40,0.55,0.75)]
        // Scyther - green
        case .scyther: return ["1":(0.50,0.75,0.40),"2":(0.50,0.75,0.40),"B":(0.12,0.12,0.15),"C":(0.85,0.85,0.80)]
        // Jynx - purple/blonde
        case .jynx: return ["1":(0.55,0.35,0.60),"2":(0.85,0.30,0.35),"A":(0.85,0.30,0.35),"B":(0.12,0.12,0.15),"C":(0.90,0.82,0.45)]
        // Electabuzz - yellow
        case .electabuzz: return ["1":(0.95,0.82,0.25),"2":(0.15,0.15,0.15),"B":(0.12,0.12,0.15),"C":(0.15,0.15,0.15)]
        // Magmar - red/orange
        case .magmar: return ["1":(0.90,0.45,0.25),"2":(0.90,0.45,0.25),"B":(0.12,0.12,0.15),"C":(0.95,0.55,0.20)]
        // Pinsir - brown
        case .pinsir: return ["1":(0.60,0.50,0.35),"2":(0.60,0.50,0.35),"B":(0.12,0.12,0.15),"C":(0.70,0.60,0.45)]
        // Tauros - brown
        case .tauros: return ["1":(0.65,0.50,0.35),"2":(0.65,0.50,0.35),"B":(0.12,0.12,0.15),"C":(0.50,0.45,0.40)]
        // Magikarp/Gyarados
        case .magikarp: return ["1":(0.90,0.50,0.25),"2":(0.95,0.85,0.55),"B":(0.12,0.12,0.15),"C":(0.90,0.50,0.25)]
        case .gyarados: return ["1":(0.35,0.50,0.80),"A":(0.90,0.90,0.85),"B":(0.75,0.15,0.15),"C":(0.30,0.40,0.70)]
        // Lapras - blue
        case .lapras: return ["1":(0.45,0.65,0.85),"2":(0.85,0.82,0.75),"B":(0.12,0.12,0.15),"C":(0.45,0.65,0.85)]
        // Ditto - purple-pink
        case .ditto: return ["1":(0.75,0.55,0.80),"2":(0.75,0.55,0.80),"B":(0.12,0.12,0.15),"C":(0.75,0.55,0.80)]
        // Eevee family
        case .eevee: return ["1":(0.70,0.50,0.30),"2":(0.90,0.82,0.65),"B":(0.12,0.12,0.15),"C":(0.85,0.70,0.50)]
        case .vaporeon: return ["1":(0.40,0.60,0.85),"2":(0.40,0.60,0.85),"B":(0.12,0.12,0.15),"C":(0.35,0.55,0.80)]
        case .jolteon: return ["1":(0.95,0.85,0.25),"2":(0.95,0.85,0.25),"B":(0.12,0.12,0.15),"C":(0.90,0.80,0.20)]
        case .flareon: return ["1":(0.90,0.55,0.25),"2":(0.90,0.55,0.25),"B":(0.12,0.12,0.15),"C":(0.95,0.45,0.20)]
        // Porygon - pink/blue
        case .porygon: return ["1":(0.90,0.55,0.55),"2":(0.45,0.60,0.85),"B":(0.12,0.12,0.15),"C":(0.90,0.55,0.55)]
        // Omanyte family - blue shell
        case .omanyte, .omastar: return ["1":(0.55,0.70,0.85),"2":(0.50,0.50,0.55),"B":(0.12,0.12,0.15),"C":(0.45,0.55,0.70)]
        // Kabuto family - brown
        case .kabuto, .kabutops: return ["1":(0.65,0.55,0.35),"2":(0.55,0.45,0.30),"B":(0.75,0.15,0.15),"C":(0.65,0.55,0.35)]
        // Aerodactyl - gray/purple
        case .aerodactyl: return ["1":(0.60,0.55,0.65),"2":(0.60,0.55,0.65),"A":(0.90,0.90,0.85),"B":(0.12,0.12,0.15),"C":(0.55,0.50,0.60)]
        // Snorlax - dark teal
        case .snorlax: return ["1":(0.25,0.35,0.40),"2":(0.85,0.82,0.75),"B":(0.12,0.12,0.15),"C":(0.25,0.35,0.40)]
        // Legendary birds
        case .articuno: return ["1":(0.50,0.70,0.90),"2":(0.50,0.70,0.90),"A":(0.50,0.70,0.90),"B":(0.12,0.12,0.15),"C":(0.35,0.55,0.85)]
        case .zapdos: return ["1":(0.95,0.85,0.30),"2":(0.95,0.85,0.30),"A":(0.95,0.85,0.30),"B":(0.12,0.12,0.15),"C":(0.90,0.70,0.20)]
        case .moltres: return ["1":(0.95,0.60,0.25),"2":(0.95,0.60,0.25),"A":(0.95,0.30,0.20),"B":(0.12,0.12,0.15),"C":(0.95,0.40,0.15)]
        // Dratini family - blue/orange
        case .dratini: return ["1":(0.45,0.60,0.85),"2":(0.45,0.60,0.85),"B":(0.12,0.12,0.15),"C":(0.85,0.85,0.90)]
        case .dragonair: return ["1":(0.45,0.60,0.85),"2":(0.45,0.60,0.85),"B":(0.12,0.12,0.15),"C":(0.85,0.85,0.90)]
        case .dragonite: return ["1":(0.90,0.65,0.30),"2":(0.85,0.80,0.60),"B":(0.12,0.12,0.15),"C":(0.45,0.70,0.50)]
        // Mewtwo/Mew
        case .mewtwo: return ["1":(0.75,0.68,0.82),"2":(0.75,0.68,0.82),"B":(0.50,0.25,0.65),"C":(0.60,0.50,0.72)]
        case .mew: return ["1":(0.95,0.72,0.78),"2":(0.95,0.72,0.78),"B":(0.35,0.50,0.80),"C":(0.95,0.60,0.70)]
        }
    }
}

// MARK: - Gacha System

struct PokemonGacha {
    static func roll() -> PokemonSpecies {
        let roll = Int.random(in: 1...100)
        let rarity: PokemonRarity
        if roll <= 3 { rarity = .legendary }
        else if roll <= 12 { rarity = .epic }
        else if roll <= 30 { rarity = .rare }
        else if roll <= 60 { rarity = .uncommon }
        else { rarity = .common }
        let pool = PokemonSpecies.allCases.filter { $0.rarity == rarity }
        return pool.randomElement()!
    }

    static func loadOrGenerate() -> PokemonSpecies {
        if let saved = UserDefaults.standard.string(forKey: "currentPokemon"),
           let species = PokemonSpecies(rawValue: saved) { return species }
        let p = roll()
        UserDefaults.standard.set(p.rawValue, forKey: "currentPokemon")
        return p
    }

    static func reroll() -> PokemonSpecies {
        let p = roll()
        UserDefaults.standard.set(p.rawValue, forKey: "currentPokemon")
        return p
    }
}

// MARK: - Pokemon Storage (caught collection, ordered by capture time)

struct PokemonStorage {
    private static let key = "caughtPokemon"

    static func caughtList() -> [String] { UserDefaults.standard.stringArray(forKey: key) ?? [] }

    static func addCaught(_ species: PokemonSpecies) {
        var list = caughtList()
        if !list.contains(species.rawValue) {
            list.append(species.rawValue)
            UserDefaults.standard.set(list, forKey: key)
        }
    }

    static func caughtSpecies() -> [PokemonSpecies] {
        caughtList().compactMap { PokemonSpecies(rawValue: $0) }
    }

    static func setActive(_ species: PokemonSpecies) {
        UserDefaults.standard.set(species.rawValue, forKey: "currentPokemon")
    }
}
