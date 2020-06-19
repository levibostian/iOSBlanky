import Foundation
import XCTest

class JsonAdapterTest: UnitTest {
    private var jsonAdapter: JsonAdapter!

    override func setUp() {
        super.setUp()

        jsonAdapter = SwiftJsonAdpter()
    }

    func test_givenDateString_expectDecode() {
        let given = "{\"test_date\": \"2020-03-30T00:00:00+00:00Z\"}"

        let actual: DateParsing = try! jsonAdapter.fromJson(given.data!)

        XCTAssertNotNil(actual)
    }

    struct DateParsing: Codable {
        let testDate: Date
    }
}
