import Foundation
import DotaFoundation

public final class RemoteHeroLoader: HeroLoaderProtocol {
    public enum Error: Swift.Error, Equatable {
        case connectivity
        case invalidData
    }

    private let client: HTTPClientProtocol
    private let url: URL

    public init(client: HTTPClientProtocol, url: URL = OpenDotaEndpoint.heroes.url) {
        self.client = client
        self.url = url
    }

    public func loadHeroes() async throws -> [Hero] {
        let data: Data
        let response: HTTPURLResponse
        do {
            (data, response) = try await client.get(from: url)
        } catch {
            throw Error.connectivity
        }
        do {
            return try HeroMapper.map(data, response: response)
        } catch {
            throw Error.invalidData
        }
    }
}
