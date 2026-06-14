import Foundation
import SwiftData

public enum SwiftDataStoreFactory {
    public static func makeInMemoryContainer() throws -> ModelContainer {
        try makeContainer(inMemory: true)
    }

    public static func makePersistentContainer() throws -> ModelContainer {
        try makeContainer(inMemory: false)
    }

    private static func makeContainer(inMemory: Bool) throws -> ModelContainer {
        let schema = Schema([HeroEntity.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: schema, configurations: [config])
    }
}
