@testable import App
import Foundation
import XCTest

class DateExtensionTest: UnitTest {
    // MARK: - humanReadableDate

    func test_humanReadableDate_givenDateInCurrentYear_expectGetStringWithoutYear() {
        let todaysYear = Date.today.year

        let dateInCurrentYear = Date.from(year: todaysYear)!

        let expected = "Jan 1"

        XCTAssertEqual(dateInCurrentYear.humanReadableDate, expected)
    }

    func test_humanReadableDate_givenDateNotInCurrentYear_expectGetStringWithYear() {
        let lastYear = Date.today.year - 1

        let dateNotInCurrentYear = Date.from(year: lastYear)!

        let expected = "Jan 1, \(lastYear)"

        XCTAssertEqual(dateNotInCurrentYear.humanReadableDate, expected)
    }

    // MARK: - isInCurrentYear

    func test_isInCurrentYear_givenToday_expectTrue() {
        XCTAssertTrue(Date.today.isInCurrentYear)
    }

    func test_isInCurrentYear_givenOldDate_expectFalse() {
        let dateNotInCurrentYear = Date.from(year: Date.today.year - 1)!

        XCTAssertFalse(dateNotInCurrentYear.isInCurrentYear)
    }

    // MARK: - random

    func test_random_expectGetDate() {
        XCTAssertNotNil(Date.random)
    }

    // MARK: - stringValue

    func test_stringValue_givenDateMadeFromStringValue_expectEqualReturnValue() {
        let givenString = "2020-02-27T11:23:55-06:00"

        let actual = Date.from(givenString)!.stringValue

        XCTAssertEqual(givenString, actual)
    }

    func test_stringValue_givenModifications_expectApplyModifications() {
        let givenDate = Date.from(hour: 11, minute: 00)!

        let actual = givenDate.stringValue(format: .time12hr, modifications: [
            .lowercase,
            .remove00
        ])

        XCTAssertEqual(actual, "11am")
    }

    // MARK: - from, with components

    func test_fromComponents_givenComponents_expectDate() {
        let actual = Date.from(year: 2017, month: 1, day: 1, hour: 13, minute: 23, second: 34)

        let expected = DateFormatter.from(string: "yyyy-MM-dd'T'HH:mm:ss").date(from: "2017-01-01T13:23:34")

        XCTAssertEqual(actual, expected)
    }

    // MARK: - add

    func test_add_givenDate_expectAddComponent() {
        let givenDate = Date.from(year: 2020, month: 1, day: 1, hour: 1, minute: 1, second: 1)
        let expected = Date.from(year: 2021, month: 3, day: 4, hour: 5, minute: 6, second: 7)

        let actual = givenDate?.add(year: 1, month: 2, day: 3, hour: 4, minute: 5, second: 6) // make each value unique to make sure we are adding the correct value to each component

        XCTAssertEqual(actual, expected)
    }

    func test_add_givenOnlySomeComponentsToAdd_expectAddComponent() {
        let givenDate = Date.from(year: 2020, month: 1, day: 1, hour: 1, minute: 1, second: 1)
        let expected = Date.from(year: 2020, month: 1, day: 2, hour: 1, minute: 2, second: 2)

        let actual = givenDate?.add(day: 1, minute: 1, second: 1)

        XCTAssertEqual(actual, expected)
    }

    // MARK: - subtract

    func test_subtract_givenDate_expectSubtractComponent() {
        let givenDate = Date.from(year: 2020, month: 6, day: 7, hour: 8, minute: 9, second: 10)
        let expected = Date.from(year: 2019, month: 4, day: 4, hour: 4, minute: 4, second: 4)

        let actual = givenDate?.subtract(year: 1, month: 2, day: 3, hour: 4, minute: 5, second: 6) // make each value unique to make sure we are adding the correct value to each component

        XCTAssertEqual(actual, expected)
    }

    func test_subtract_givenOnlySomeComponentsToSubtract_expectSubtractComponent() {
        let givenDate = Date.from(year: 2020, month: 10, day: 10, hour: 10, minute: 10, second: 10)
        let expected = Date.from(year: 2020, month: 10, day: 9, hour: 10, minute: 9, second: 9)

        let actual = givenDate?.subtract(day: 1, minute: 1, second: 1)

        XCTAssertEqual(actual, expected)
    }
}

class FormatStringTest: UnitTest {
    func test_shortMonthDay_givenDate_expectFormat() {
        let givenDate = Date.from(month: 1, day: 1)!

        let actual = givenDate.stringValue(format: .shortMonthDay)

        XCTAssertEqual(actual, "Jan 1")
    }

    func test_time12hr_givenDate_expectFormat() {
        let givenDate = Date.from(hour: 11, minute: 0)!

        let actual = givenDate.stringValue(format: .time12hr)

        XCTAssertEqual(actual, "11:00AM")
    }
}

class ModifyDateStringTest: UnitTest {
    // MARK: - lowercase

    func test_lowercase_modify_givenLowercase_expectSameString() {
        let given = "1pm"
        let expected = "1pm"

        let actual = ModifyDateString.lowercase.modify(given)

        XCTAssertEqual(actual, expected)
    }

    func test_lowercase_modify_givenUppercaseMultipleCharacters_expectLowercaseString() {
        let given = "1PM"
        let expected = "1pm"

        let actual = ModifyDateString.lowercase.modify(given)

        XCTAssertEqual(actual, expected)
    }

    func test_lowercase_modify_givenEmptyString_expectEmptyString() {
        let given = ""
        let expected = ""

        let actual = ModifyDateString.lowercase.modify(given)

        XCTAssertEqual(actual, expected)
    }

    // MARK: - remove00

    func test_remove00_modify_givenNo00_expectSameString() {
        let given = "2:15PM"
        let expected = "2:15PM"

        let actual = ModifyDateString.remove00.modify(given)

        XCTAssertEqual(actual, expected)
    }

    func test_remove00_modify_given00_expectRemove00() {
        let given = "1:00PM"
        let expected = "1PM"

        let actual = ModifyDateString.remove00.modify(given)

        XCTAssertEqual(actual, expected)
    }

    func test_remove00_modify_givenEmptyString_expectEmptyString() {
        let given = ""
        let expected = ""

        let actual = ModifyDateString.remove00.modify(given)

        XCTAssertEqual(actual, expected)
    }

    // MARK: - daysBetween

    func test_daysBetween_givenDatesBothSameDate_expect0() {
        let date1 = Date.from(hour: 1, minute: 0, second: 0)!
        let date2 = Date.from(hour: 1, minute: 1, second: 0)!

        XCTAssertEqual(date1.daysBetween(date2), 0)
    }

    func test_daysBetween_givenDatesOneDayApart_expect1() {
        let date1 = Date.from(year: 2020, month: 1, day: 1)!
        let date2 = Date.from(year: 2020, month: 1, day: 2)!

        XCTAssertEqual(date1.daysBetween(date2), 1)
    }

    // This test is where we are going over multiple months. Make sure the logic works still.
    func test_daysBetween_givenDates40DaysApart_expect40() {
        let date1 = Date.from(year: 2020, month: 1, day: 1)!
        let date2 = Date.from(year: 2020, month: 2, day: 10)!

        XCTAssertEqual(date1.daysBetween(date2), 40)
    }

    // MARK: - sequence

    func test_sequence_givenSameDates_expect1() {
        let given1 = Date.now
        let given2 = given1

        let actual = given1.sequence(to: given2, by: .day)

        var count = 0
        var expected = [
            given1
        ]
        for item in actual {
            XCTAssertEqual(item, expected.removeFirst())
            count += 1
        }

        XCTAssertEqual(count, 1)
    }

    func test_sequence_givenDates_expectSequence() {
        let given1 = Date.now
        let given2 = given1.add(day: 2)

        let actual = given1.sequence(to: given2, by: .day)

        var count = 0
        var expected = [
            given1,
            given1.add(day: 1),
            given1.add(day: 2)
        ]
        for item in actual {
            XCTAssertEqual(item, expected.removeFirst())
            count += 1
        }

        XCTAssertEqual(count, 3)
    }

    func test_sequence_givenDatesWrongOrder_expectSequence() {
        let given1 = Date.now
        let given2 = given1.subtract(day: 2)

        let actual = given1.sequence(to: given2, by: .day)

        var count = 0
        var expected = [
            given2,
            given2.add(day: 1),
            given2.add(day: 2)
        ]
        for item in actual {
            XCTAssertEqual(item, expected.removeFirst())
            count += 1
        }

        XCTAssertEqual(count, 3)
    }
}
