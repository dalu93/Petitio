import XCTest
@testable import Petitio

final class PetitioTests: XCTestCase {
    func testSendRequestAndExpect200() throws {
        let response = try Petitio.get(
            at: "http://www.recipepuppy.com/api/?i=onions,garlic&q=omelet&p=3",
            parameters: [:]
        ).wait()

        XCTAssertEqual(response.status, .ok)
    }

    static var allTests = [
        ("testSendRequestAndExpect200", testSendRequestAndExpect200),
    ]
}
