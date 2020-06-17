import Dwifft
import Foundation
import UIKit

/**
 Wrapper around UITableView that makes use of Dwifft super easy.

 Notes about this class:
 * Dwifft requires 1 data type (that's equatable) to be used.
 * Dwifft's data structure is: [(Equatable, [DataType])]. Where tuple.0 is the section header and tuple.1 is the array of values for that section. Dwifft allows duplicates for tuple.0. Dwifft will simply create new sections for you with the same header. But, in this class, we are not allowing duplicates which means tuple.0 is used as a key instead of a header value. This allows you to edit the values of each section separately from each other by setting the sections individually. So, note that we are using Dwifft in a little different way here as we are enforcing tuple.0 to be unique.
 */
class DiffableUITableView<DataType: Equatable>: UITableView {
    private var diffCalculator: TableViewDiffCalculator<String, DataType>!

    /// Call for `func numberOfSections(in tableView: UITableView) -> Int`
    override var numberOfSections: Int {
        diffCalculator.numberOfSections()
    }

    convenience init() {
        self.init(frame: CGRect.zero)

        build()
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        build()
    }

    /// Will override the values currently set for the tableview.
    /// If you want to override just 1 section's values, use the other set function.
    func set(_ newValues: [(String, [DataType])]) {
        diffCalculator.sectionedValues = SectionedValues(newValues)
    }

    /// Set the new values for the section. This overrides previous values set for the section.
    func set(_ newValues: [DataType], forSection section: String) {
        let existingSectionedValues = diffCalculator.sectionedValues.sectionsAndValues

        var newSectionedValues: [(String, [DataType])] = []

        var existingContainsSection = false
        existingSectionedValues.forEach { existingSectionedValue in
            if existingSectionedValue.0 == section {
                existingContainsSection = true
                newSectionedValues.append((section, newValues))
            } else {
                newSectionedValues.append(existingSectionedValue)
            }
        }

        if !existingContainsSection {
            newSectionedValues.append((section, newValues))
        }

        diffCalculator.sectionedValues = SectionedValues(newSectionedValues)
    }

    private func build() {
        diffCalculator = TableViewDiffCalculator(tableView: self)
        diffCalculator.insertionAnimation = .bottom
        diffCalculator.deletionAnimation = .bottom
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func rows(forSection section: String) -> [DataType] {
        var rows: [DataType] = []

        diffCalculator.sectionedValues.sectionsAndValues.forEach { entry in
            if entry.0 == section {
                rows.append(contentsOf: entry.1)
            }
        }

        return rows
    }

    func section(at index: Int) -> String {
        diffCalculator.value(forSection: index)
    }

    /// Call for `func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int`
    override func numberOfRows(inSection section: Int) -> Int {
        diffCalculator.numberOfObjects(inSection: section)
    }

    func value(atIndexPath indexPath: IndexPath) -> DataType {
        diffCalculator.value(atIndexPath: indexPath)
    }
}
