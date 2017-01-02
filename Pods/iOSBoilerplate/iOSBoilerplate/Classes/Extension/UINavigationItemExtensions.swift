//
//  UINavigationItemExtensions.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation
import UIKit

public extension UINavigationItem {
    
    public func navigationBarTitleButton(titleText: String, target: Any, selector: Selector, navigationController: UINavigationController?) {
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
