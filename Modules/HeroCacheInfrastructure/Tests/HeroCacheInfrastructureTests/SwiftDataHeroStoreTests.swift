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

    // MARK: - list (retrieve)

    @Test func list_deliversEmptyOnEmptyCache() async throws {
        let sut = try makeSUT()

        try await expect(sut, toList: [])
    }

    @Test func list_hasNoSideEffectsOnEmptyCache() async throws {
        let sut = try makeSUT()

        try await expect(sut, toListTwice: [])
    }

    @Test func list_deliversSavedHeroesOnNonEmptyCache() async throws {
        let sut = try makeSUT()

        try await sut.save(Hero.mocks)

        try await expect(sut, toList: Hero.mocks)
    }

    @Test func list_hasNoSideEffectsOnNonEmptyCache() async throws {
        let sut = try makeSUT()

        try await sut.save(Hero.mocks)

        try await expect(sut, toListTwice: Hero.mocks)
    }

    // MARK: - save (insert / override)

    @Test func save_deliversNoErrorOnEmptyCache() async throws {
        let sut = try makeSUT()

        let error = await save(Hero.mocks, to: sut)

        #expect(error == nil)
    }

    @Test func save_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = try makeSUT()
        try await sut.save(Hero.mocks)

        let error = await save([Hero.mock(id: 7, slug: "earthshaker", localizedName: "Earthshaker")], to: sut)

        #expect(error == nil)
    }

    @Test func save_overridesPreviouslySavedHeroes() async throws {
        let sut = try makeSUT()

        try await sut.save([Hero.mock(id: 99, slug: "techies", localizedName: "Techies")])
        try await sut.save(Hero.mocks)

        try await expect(sut, toList: Hero.mocks)
    }

    // MARK: - save([]) — clears the cache (delete-equivalent)

    @Test func saveEmpty_deliversNoErrorOnEmptyCache() async throws {
        let sut = try makeSUT()

        let error = await save([], to: sut)

        #expect(error == nil)
    }

    @Test func saveEmpty_clearsPreviouslySavedHeroes() async throws {
        let sut = try makeSUT()

        try await sut.save(Hero.mocks)
        try await sut.save([])

        try await expect(sut, toList: [])
    }

    // MARK: - Helpers

    private func makeSUT(sourceLocation: SourceLocation = #_sourceLocation) throws -> SwiftDataHeroStore {
        let container = try SwiftDataStoreFactory.makeInMemoryContainer()
        let sut = SwiftDataHeroStore(modelContainer: container)
        let tracker = MemoryLeakTracker(instance: sut, sourceLocation: sourceLocation)
        leakTrackers.withValue { $0.append(tracker) }
        return sut
    }

    @discardableResult
    private func save(_ heroes: [Hero], to sut: SwiftDataHeroStore) async -> Error? {
        do {
            try await sut.save(heroes)
            return nil
        } catch {
            return error
        }
    }

    private func expect(
        _ sut: SwiftDataHeroStore,
        toList expected: [Hero],
        sourceLocation: SourceLocation = #_sourceLocation
    ) async throws {
        let result = try await sut.list()
        #expect(result == expected, sourceLocation: sourceLocation)
    }

    private func expect(
        _ sut: SwiftDataHeroStore,
        toListTwice expected: [Hero],
        sourceLocation: SourceLocation = #_sourceLocation
    ) async throws {
        try await expect(sut, toList: expected, sourceLocation: sourceLocation)
        try await expect(sut, toList: expected, sourceLocation: sourceLocation)
    }
}
