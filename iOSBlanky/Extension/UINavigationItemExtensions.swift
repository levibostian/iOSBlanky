//
//  UINavigationItemExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationItem {
    
    func navigationBarTitleButton(titleText: String, target: Any, selector: Selector, navigationController: UINavigationController?) {
        if let navigationController = navigationController {
            let button =  UIButton(type: .custom)
            button.frame = navigationController.navigationBar.topItem!.titleView!.frame
            //        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40) // not using because not dynamic width.
            button.setTitle(titleText, for: UIControlState.normal)
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
            
            button.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
            
            titleView = button
        }
    }
    
}
