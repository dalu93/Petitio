import XCTest
@testable import Petitio

final class URLEncoderTests: XCTestCase {

    func testGenerateCorrectURLWithAllValidParams() throws {
        let initialURL = URL(string: "https://github.com")!
        let descriptor = URLRequestDescriptor(
            url: initialURL,
            method: .GET,
            headers: [:],
            parameters: [
                "q": "dalu93",
                "page": 1
            ],
            httpVersion: HTTPVersion(major: 1, minor: 1)
        )

        let encoder = URLEncoder()
        let expectedRequest = HTTPRequest(
            method: .GET,
            url: "https://github.com?q=dalu93&page=1",
            version: HTTPVersion(major: 1, minor: 1),
            headers: [:],
            body: EmptyBody()
        )

        let result = try encoder.encode(descriptor)
        XCTAssertEqual(expectedRequest.method, result.method)
        XCTAssertEqual(expectedRequest.version, result.version)
        XCTAssertEqual(expectedRequest.headers, result.headers)
        XCTAssertEqual(expectedRequest.body.data, result.body.data)

        XCTAssertTrue(verifyQuery(expectedRequest.url, result.url))
    }

    func testGenerateWithURLThatAlreadyContainsAQueryString() throws {
        let initialURL = URL(string: "https://github.com/?foo=bar")!
        let descriptor = URLRequestDescriptor(
            url: initialURL,
            method: .GET,
            headers: [:],
            parameters: [
                "q": "dalu93",
                "page": 1
            ],
            httpVersion: HTTPVersion(major: 1, minor: 1)
        )

        let encoder = URLEncoder()
        let expectedRequest = HTTPRequest(
            method: .GET,
            url: "https://github.com?foo=bar&q=dalu93&page=1",
            version: HTTPVersion(major: 1, minor: 1),
            headers: [:],
            body: EmptyBody()
        )

        let result = try encoder.encode(descriptor)
        XCTAssertEqual(expectedRequest.method, result.method)
        XCTAssertEqual(expectedRequest.version, result.version)
        XCTAssertEqual(expectedRequest.headers, result.headers)
        XCTAssertEqual(expectedRequest.body.data, result.body.data)
        XCTAssertTrue(verifyQuery(expectedRequest.url, result.url))
    }

    func testGenerateWithNoParameters() throws {
        let initialURL = URL(string: "https://github.com")!
        let descriptor = URLRequestDescriptor(
            url: initialURL,
            method: .GET,
            headers: [:],
            parameters: [:],
            httpVersion: HTTPVersion(major: 1, minor: 1)
        )

        let encoder = URLEncoder()
        let expectedRequest = HTTPRequest(
            method: .GET,
            url: "https://github.com?",
            version: HTTPVersion(major: 1, minor: 1),
            headers: [:],
            body: EmptyBody()
        )

        let result = try encoder.encode(descriptor)
        XCTAssertEqual(expectedRequest.method, result.method)
        XCTAssertEqual(expectedRequest.version, result.version)
        XCTAssertEqual(expectedRequest.headers, result.headers)
        XCTAssertEqual(expectedRequest.body.data, result.body.data)
        XCTAssertEqual(expectedRequest.url, result.url)
    }

    static var allTests = [
        ("testGenerateCorrectURLWithAllValidParams", testGenerateCorrectURLWithAllValidParams),
        ("testGenerateWithURLThatAlreadyContainsAQueryString", testGenerateWithURLThatAlreadyContainsAQueryString),
        ("testGenerateWithNoParameters", testGenerateWithNoParameters),

    ]
}

private extension URLEncoderTests {
    func verifyQuery(_ url1: URL, _ url2: URL) -> Bool {
        let url1QueryElements = url1.query!.components(separatedBy: "&").sorted()
        let url2QueryElements = url2.query!.components(separatedBy: "&").sorted()
        return url1QueryElements == url2QueryElements
    }
}
