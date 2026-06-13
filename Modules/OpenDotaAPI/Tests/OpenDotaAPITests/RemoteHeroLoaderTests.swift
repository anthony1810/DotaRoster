import Testing
import Foundation
import ConcurrencyExtras
import DotaFoundation
import OpenDotaAPI

final class RemoteHeroLoaderTests {
    private let leakTrackers = LockIsolated<[MemoryLeakTracker]>([])

    deinit {
        leakTrackers.value.forEach { $0.verify() }
    }

    @Test func init_doesNotRequestData() {
        let (_, client) = makeSUT()

        #expect(client.requestedURLs.isEmpty)
    }

    @Test func loadHeroes_requestsDataFromURL() async {
        let url = URL(string: "https://api.opendota.com/api/heroes")!
        let (sut, client) = makeSUT(url: url)
        client.complete(withStatusCode: 200, data: emptyHeroesJSON())

        _ = try? await sut.loadHeroes()

        #expect(client.requestedURLs == [url])
    }

    @Test func loadHeroes_deliversConnectivityErrorOnClientError() async {
        let (sut, client) = makeSUT()
        client.complete(with: anyNSError())

        await #expect(throws: RemoteHeroLoader.Error.connectivity) {
            try await sut.loadHeroes()
        }
    }

    @Test func loadHeroes_deliversInvalidDataErrorOnNon200() async {
        let (sut, client) = makeSUT()
        client.complete(withStatusCode: 500, data: emptyHeroesJSON())

        await #expect(throws: RemoteHeroLoader.Error.invalidData) {
            try await sut.loadHeroes()
        }
    }

    @Test func loadHeroes_deliversHeroesOn200() async throws {
        let (sut, client) = makeSUT()
        client.complete(withStatusCode: 200, data: try fixtureData(named: "heroes_200"))

        let heroes = try await sut.loadHeroes()

        #expect(heroes.map(\.slug) == ["antimage", "axe", "crystal_maiden", "abaddon"])
    }

    // MARK: - Helpers

    private func makeSUT(
        url: URL = anyURL(),
        sourceLocation: SourceLocation = #_sourceLocation
    ) -> (sut: RemoteHeroLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteHeroLoader(client: client, url: url)
        track(client, sourceLocation: sourceLocation)
        track(sut, sourceLocation: sourceLocation)
        return (sut, client)
    }

    private func track(_ instance: AnyObject, sourceLocation: SourceLocation) {
        let tracker = MemoryLeakTracker(instance: instance, sourceLocation: sourceLocation)
        leakTrackers.withValue { $0.append(tracker) }
    }
}
