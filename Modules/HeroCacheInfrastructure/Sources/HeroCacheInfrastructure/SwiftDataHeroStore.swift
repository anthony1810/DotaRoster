import Foundation
import SwiftData
import DotaFoundation

@ModelActor
public actor SwiftDataHeroStore: HeroStoreProtocol {
    public func save(_ heroes: [Hero]) async throws {
        try modelContext.delete(model: HeroEntity.self)
        for hero in heroes {
            modelContext.insert(HeroEntity(from: hero))
        }
        try modelContext.save()
    }

    public func list() async throws -> [Hero] {
        let descriptor = FetchDescriptor<HeroEntity>(
            sortBy: [SortDescriptor(\.localizedName, order: .forward)]
        )
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }
}
