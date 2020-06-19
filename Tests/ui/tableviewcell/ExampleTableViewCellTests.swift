@testable import App
import Foundation
import XCTest

class ExampleTableViewCellTests: XCTestCase {
    private var cell: ExampleTableViewCell!

    override func setUp() {
        super.setUp()

        cell = ExampleTableViewCell(style: .default, reuseIdentifier: nil)
    }

    func test_givenListItem_expectTitleSet() {
        let givenListItem = "foo"
        cell.listItem = givenListItem

        cell.titleLabel.text = givenListItem
    }
}
