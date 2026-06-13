import Foundation

struct Hero: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let localizedName: String
    let primaryAttr: String
    let attackType: String
    let roles: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, roles
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
    }

    var slug: String {
        name.replacingOccurrences(of: "npc_dota_hero_", with: "")
    }

    var portraitURL: URL? {
        URL(string: "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/\(slug).png")
    }

    var attributeLabel: String {
        switch primaryAttr {
        case "str": return "Strength"
        case "agi": return "Agility"
        case "int": return "Intelligence"
        case "all": return "Universal"
        default: return primaryAttr.capitalized
        }
    }

    var attributeTint: AttributeTint { AttributeTint(primaryAttr) }
}

struct HeroLine: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let audioURL: URL?

    init(_ text: String, audioURL: URL? = nil) {
        self.text = text
        self.audioURL = audioURL
    }
}

enum AttributeTint {
    case strength, agility, intelligence, universal

    init(_ raw: String) {
        switch raw {
        case "str": self = .strength
        case "agi": self = .agility
        case "int": self = .intelligence
        default: self = .universal
        }
    }
}
