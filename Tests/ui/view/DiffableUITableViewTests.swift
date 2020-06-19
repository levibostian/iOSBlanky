@testable import App
import Foundation
import XCTest

class DiffableUITableViewTests: XCTestCase {
    private var tableView: DiffableUITableView<String>!

    override func setUp() {
        super.setUp()

        tableView = DiffableUITableView()
    }

    func test_set_givenNewValuesSameSection_expectOverwriteFirstValues() {
        let given1 = ["first1", "first2"]
        let given2 = ["second1", "second2", "second3"]
        let section = "Section"

        tableView.set(given1, forSection: section)
        tableView.set(given2, forSection: section)

        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), given2.count)
    }

    func test_set_givenValuesMultipleSections_expectValuesForMultipleSections() {
        let given1 = ["first1", "first2"]
        let given2 = ["second1", "second2", "second3"]
        let section1 = "Section1"
        let section2 = "Section2"

        tableView.set(given1, forSection: section1)
        tableView.set(given2, forSection: section2)

        XCTAssertEqual(tableView.numberOfSections, 2)
        XCTAssertEqual(tableView.rows(forSection: section1).count, given1.count)
        XCTAssertEqual(tableView.rows(forSection: section2).count, given2.count)
    }

    func test_rows_givenEmpty_expectEmpty() {
        let actual = tableView.rows(forSection: "Section")

        XCTAssertTrue(actual.isEmpty)
    }

    func test_rows_givenRowsInADifferentSection_expectEmpty() {
        tableView.set(["new1"], forSection: "DiffSection")
        let actual = tableView.rows(forSection: "Section")

        XCTAssertTrue(actual.isEmpty)
    }

    func test_rows_givenRowsInSection_expectGetRows() {
        let given = ["new1"]
        let givenSection = "Section"

        tableView.set(given, forSection: givenSection)
        let actual = tableView.rows(forSection: givenSection)

        let expect = given

        XCTAssertEqual(actual, expect)
    }
}
