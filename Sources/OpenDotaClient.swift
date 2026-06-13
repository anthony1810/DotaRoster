import Foundation

protocol HeroLoading: Sendable {
    func loadHeroes() async throws -> [Hero]
}

struct OpenDotaClient: HeroLoading {
    private let endpoint = URL(string: "https://api.opendota.com/api/heroes")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadHeroes() async throws -> [Hero] {
        let (data, response) = try await session.data(from: endpoint)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let heroes = try JSONDecoder().decode([Hero].self, from: data)
        return heroes.sorted { $0.localizedName < $1.localizedName }
    }
}
