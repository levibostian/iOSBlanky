import Foundation
import UIKit

class BasePopoverViewController: UIViewController {
    func setupPopover(_ delegate: UIPopoverPresentationControllerDelegate, arrowDirection: UIPopoverArrowDirection, sourceView: UIView?, sourceRect: CGRect) {
        modalPresentationStyle = .popover
        preferredContentSize = getPreferredContentSize()

        if let popoverController = popoverPresentationController {
            popoverController.delegate = delegate
            popoverController.permittedArrowDirections = arrowDirection
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceRect
        }
    }

    // override in child instances to specify size.
    func getPreferredContentSize() -> CGSize {
        CGSize(width: 200, height: 200)
    }

    func dismiss(_: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
