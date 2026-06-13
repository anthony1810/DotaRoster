import Foundation
import ConcurrencyExtras
import OpenDotaAPI

final class HTTPClientSpy: HTTPClientProtocol, Sendable {
    private let _requestedURLs = LockIsolated<[URL]>([])
    private let _result = LockIsolated<Result<(Data, HTTPURLResponse), Error>?>(nil)

    var requestedURLs: [URL] { _requestedURLs.value }

    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        _requestedURLs.withValue { $0.append(url) }
        guard let result = _result.value else {
            throw NSError(domain: "HTTPClientSpy", code: -1)
        }
        return try result.get()
    }

    func complete(withStatusCode code: Int, data: Data, url: URL = anyURL()) {
        let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
        _result.setValue(.success((data, response)))
    }

    func complete(with error: Error) {
        _result.setValue(.failure(error))
    }
}
