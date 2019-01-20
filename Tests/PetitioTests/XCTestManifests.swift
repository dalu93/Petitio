import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PetitioTests.allTests),
        testCase(RequireHostTests.allTests),
        testCase(RequireSchemeTests.allTests),
        testCase(URLEncoderTests.allTests),
        testCase(BodyJSONEncoderTests.allTests),
    ]
}
#endif
