import XCTest

import PetitioTests

var tests = [XCTestCaseEntry]()
tests += PetitioTests.allTests()
XCTMain(tests)