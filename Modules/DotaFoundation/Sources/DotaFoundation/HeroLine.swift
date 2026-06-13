import Foundation

public struct HeroLine: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let text: String
    public let audioURL: URL?

    public init(id: UUID = UUID(), text: String, audioURL: URL? = nil) {
        self.id = id
        self.text = text
        self.audioURL = audioURL
    }
}
