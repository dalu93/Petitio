import XCTest
@testable import Petitio

final class RequireHostTests: XCTestCase {
    func testGetHostWhenHostIsPresent() {
        let expectedHost = "github.com"
        let url = URL(string: "https://\(expectedHost)")!
        let host = try? url.requireHost()
        XCTAssertNotNil(host)
        XCTAssertEqual(expectedHost, host)
    }

    func testThrowErrorWhenHostIsNotPresent() {
        let url = URL(string: "0.0.0.0")!
        do {
            let host = try url.requireHost()
            XCTFail("Received \(host), expected none")
        } catch { }
    }

    static var allTests = [
        ("testGetHostWhenHostIsPresent", testGetHostWhenHostIsPresent),
        ("testThrowErrorWhenHostIsNotPresent", testThrowErrorWhenHostIsNotPresent),
    ]
}

