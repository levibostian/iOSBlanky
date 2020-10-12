@testable import App
import Foundation
import XCTest

class RatingUtilTest: UnitTest {
    func test_getRatingArray_givenRating0_expectAllFalse() {
        XCTAssertEqual(RatingUtil.getRatingArray(rating: 0, outof: 5), [false, false, false, false, false])
    }

    func test_getRatingArray_givenRatingEqualMax_expectAllTrue() {
        XCTAssertEqual(RatingUtil.getRatingArray(rating: 5, outof: 5), [true, true, true, true, true])
    }

    func test_getRatingArray_givenRatingBetweenMax_expectSomeTrueSomeFalse() {
        XCTAssertEqual(RatingUtil.getRatingArray(rating: 2, outof: 5), [true, true, false, false, false])
    }
}
