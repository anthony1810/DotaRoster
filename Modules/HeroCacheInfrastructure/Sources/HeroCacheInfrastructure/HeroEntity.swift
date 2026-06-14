import Foundation
import SwiftData
import DotaFoundation

@Model
final class HeroEntity {
    @Attribute(.unique) var id: Int
    var slug: String
    var localizedName: String
    var primaryAttrCode: String
    var attackType: String
    var roles: [String]

    init(id: Int, slug: String, localizedName: String, primaryAttrCode: String, attackType: String, roles: [String]) {
        self.id = id
        self.slug = slug
        self.localizedName = localizedName
        self.primaryAttrCode = primaryAttrCode
        self.attackType = attackType
        self.roles = roles
    }
}

extension HeroEntity {
    convenience init(from hero: Hero) {
        self.init(
            id: hero.id,
            slug: hero.slug,
            localizedName: hero.localizedName,
            primaryAttrCode: hero.primaryAttr.storageCode,
            attackType: hero.attackType,
            roles: hero.roles
        )
    }

    func toDomain() -> Hero {
        Hero(
            id: id,
            slug: slug,
            localizedName: localizedName,
            primaryAttr: PrimaryAttribute(storageCode: primaryAttrCode) ?? .universal,
            attackType: attackType,
            roles: roles
        )
    }
}

private extension PrimaryAttribute {
    var storageCode: String {
        switch self {
        case .strength: "strength"
        case .agility: "agility"
        case .intelligence: "intelligence"
        case .universal: "universal"
        }
    }

    init?(storageCode: String) {
        switch storageCode {
        case "strength": self = .strength
        case "agility": self = .agility
        case "intelligence": self = .intelligence
        case "universal": self = .universal
        default: return nil
        }
    }
}
