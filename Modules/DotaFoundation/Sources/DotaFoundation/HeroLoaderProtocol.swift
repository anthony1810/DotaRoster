public protocol HeroLoaderProtocol: Sendable {
    func loadHeroes() async throws -> [Hero]
}
