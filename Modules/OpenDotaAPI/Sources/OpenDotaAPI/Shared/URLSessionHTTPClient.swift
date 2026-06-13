import Foundation

public final class URLSessionHTTPClient: HTTPClientProtocol {
    public enum Error: Swift.Error {
        case nonHTTPResponse
    }

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.nonHTTPResponse
        }
        return (data, httpResponse)
    }
}
