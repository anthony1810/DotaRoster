import DotaFoundation

extension PrimaryAttribute {
    init(openDotaCode code: String) {
        switch code {
        case "str": self = .strength
        case "agi": self = .agility
        case "int": self = .intelligence
        default: self = .universal
        }
    }
}
