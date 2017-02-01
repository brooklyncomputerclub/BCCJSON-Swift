import XCTest
@testable import BCCJSON_Swift

class BCCJSON_SwiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(BCCJSON_Swift().text, "Hello, World!")
    }


    static var allTests : [(String, (BCCJSON_SwiftTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
