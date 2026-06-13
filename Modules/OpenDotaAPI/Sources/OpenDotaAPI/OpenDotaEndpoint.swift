import Foundation

public enum OpenDotaEndpoint {
    case heroes
    case heroStats

    public var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.opendota.com"
        switch self {
        case .heroes:
            components.path = "/api/heroes"
        case .heroStats:
            components.path = "/api/heroStats"
        }
        return components.url!
    }
}
