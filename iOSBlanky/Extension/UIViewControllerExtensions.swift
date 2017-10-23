//
//  UIViewControllerExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/23/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import UIKit
import SwiftOverlays

extension UIViewController {
    
    func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
    }
    
    func setBackButtonText(_ text: String = " ") {
        let backItem = UIBarButtonItem()
        backItem.title = text
        navigationItem.backBarButtonItem = backItem
    }
    
    func setNavigationBarTitle(_ text: String = " ") {
        if self.navigationItem.titleView is UIButton {
            (self.navigationItem.titleView as! UIButton).setTitle(text, for: UIControlState.normal) // swiftlint:disable:this force_cast
        } else {
            self.navigationController?.navigationBar.topItem?.title = text
        }
    }
    
}

// MARK: Loading overlay
extension UIViewController {
    
    func showLoadingOverlay(text: String) {
        self.showWaitOverlayWithText(text)
    }
    
    func hideLoadingOverlay() {
        self.removeAllOverlays()
    }
    
}
