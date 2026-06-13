import Foundation

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func anyNSError() -> NSError {
    NSError(domain: "test", code: 0)
}

func makeHTTPResponse(statusCode: Int) -> HTTPURLResponse {
    HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func emptyHeroesJSON() -> Data {
    Data("[]".utf8)
}

func fixtureData(named name: String) throws -> Data {
    guard let url = Bundle.module.url(forResource: name, withExtension: "json") else {
        throw NSError(domain: "fixture", code: 404, userInfo: [NSLocalizedDescriptionKey: "Missing fixture \(name).json"])
    }
    return try Data(contentsOf: url)
}
