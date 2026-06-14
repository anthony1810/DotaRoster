import Foundation

public protocol HTTPClientProtocol: Sendable {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}
