//
//  BasePopoverViewController.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

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
        return CGSize(width: 200, height: 200)
    }
    
    func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
