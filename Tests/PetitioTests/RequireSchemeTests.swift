import XCTest
@testable import Petitio

final class RequireSchemeTests: XCTestCase {
    func testGetSchemeWhenSchemeIsPresent() {
        let expectedScheme = HTTPScheme.https
        let url = URL(string: "https://github.com")!
        let scheme = try? url.requireScheme()
        XCTAssertNotNil(scheme)
        XCTAssertEqual(expectedScheme.defaultPort, scheme?.defaultPort)
    }

    func testThrowErrorWhenSchemeIsNotPresent() {
        let url = URL(string: "0.0.0.0")!
        do {
            let scheme = try url.requireScheme()
            XCTFail("Received \(scheme), expected none")
        } catch { }
    }

    static var allTests = [
        ("testGetSchemeWhenSchemeIsPresent", testGetSchemeWhenSchemeIsPresent),
        ("testThrowErrorWhenSchemeIsNotPresent", testThrowErrorWhenSchemeIsNotPresent),
        ]
}

