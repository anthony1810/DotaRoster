public protocol HeroStoreProtocol: Sendable {
    func save(_ heroes: [Hero]) async throws
    func list() async throws -> [Hero]
}
