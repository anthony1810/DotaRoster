import Testing
import Foundation
import ConcurrencyExtras
import DotaFoundation
import HeroCacheInfrastructure

final class SwiftDataHeroStoreTests {
    private let leakTrackers = LockIsolated<[MemoryLeakTracker]>([])

    deinit {
        leakTrackers.value.forEach { $0.verify() }
    }

    @Test func list_deliversEmptyOnEmptyCache() async throws {
        let sut = try makeSUT()

        let result = try await sut.list()

        #expect(result.isEmpty)
    }

    @Test func saveThenList_deliversSavedHeroes() async throws {
        let sut = try makeSUT()

        try await sut.save(Hero.mocks)
        let result = try await sut.list()

        #expect(result == Hero.mocks)
    }

    @Test func save_replacesPreviousCache() async throws {
        let sut = try makeSUT()

        try await sut.save([Hero.mock(id: 99, slug: "techies", localizedName: "Techies")])
        try await sut.save(Hero.mocks)
        let result = try await sut.list()

        #expect(result == Hero.mocks)
    }

    // MARK: - Helpers

    private func makeSUT(sourceLocation: SourceLocation = #_sourceLocation) throws -> SwiftDataHeroStore {
        let container = try SwiftDataStoreFactory.makeInMemoryContainer()
        let sut = SwiftDataHeroStore(modelContainer: container)
        let tracker = MemoryLeakTracker(instance: sut, sourceLocation: sourceLocation)
        leakTrackers.withValue { $0.append(tracker) }
        return sut
    }
}
