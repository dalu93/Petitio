import XCTest
import HTTP
@testable import Petitio

class BodyJSONEncoderTests: XCTestCase {

    func testGenerateOfDataFromDictionary() throws {
        let dictionaryToEncode = [
            "hello": "world",
            "text": "test",
        ]

        let requestDescriptor = URLRequestDescriptor(
            url: URL(string: "http://www.google.com")!,
            method: .POST,
            headers: [:],
            parameters: dictionaryToEncode,
            httpVersion: HTTPVersion(major: 1, minor: 1)
        )

        let encoder = BodyJSONEncoder()
        let encodedData = try encoder.encode(requestDescriptor).body.data
        XCTAssertNotNil(encodedData)

        let decoded = try JSONSerialization.jsonObject(
            with: encodedData!,
            options: .allowFragments
        ) as? [String: String]

        XCTAssertEqual(decoded, dictionaryToEncode)
    }
    
    static var allTests = [
        ("testGenerateOfDataFromDictionary", testGenerateOfDataFromDictionary),
    ]
}
