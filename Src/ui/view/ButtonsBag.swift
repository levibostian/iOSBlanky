import Foundation
import UIKit

/**
 When you want to display 2+ buttons in a view, sometimes they can be difficult to manage. This class manages them for you. You just need to style them and add them to your view.
 */
class ButtonsBag<ID: Any> {
    private var buttonIdentifiers: [ID] = []

    var isEmpty: Bool {
        count <= 0
    }

    var count: Int {
        buttonIdentifiers.count
    }

    private var nextButtonTag: Int {
        buttonIdentifiers.count + 1
    }

    func create(identifier: ID) -> UIButton {
        let button = UIButton()
        button.tag = nextButtonTag

        buttonIdentifiers.append(identifier)

        return button
    }

    func getIdentifier(for button: UIButton) -> ID? {
        let index = (button.tag - 1)

        return buttonIdentifiers[safe: index]
    }
}
