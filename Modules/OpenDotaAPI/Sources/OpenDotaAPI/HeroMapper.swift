import Foundation
import DotaFoundation

public enum HeroMapper {
    public enum Error: Swift.Error, Equatable {
        case invalidResponse
        case invalidJSON
    }

    public static func map(_ data: Data, response: HTTPURLResponse) throws -> [Hero] {
        guard response.statusCode == 200 else {
            throw Error.invalidResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let dtos = try? decoder.decode([HeroDTO].self, from: data) else {
            throw Error.invalidJSON
        }
        return dtos.map { $0.toDomain() }
    }
}

private struct HeroDTO: Decodable {
    let id: Int
    let name: String
    let localizedName: String
    let primaryAttr: String
    let attackType: String
    let roles: [String]

    func toDomain() -> Hero {
        Hero(
            id: id,
            slug: name.replacingOccurrences(of: "npc_dota_hero_", with: ""),
            localizedName: localizedName,
            primaryAttr: PrimaryAttribute(openDotaCode: primaryAttr),
            attackType: attackType,
            roles: roles
        )
    }
}
