//
//  UITableViewExtensions.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation
import UIKit

public extension UITableView {
    
    public func dynamicCellHeight() {
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 40.0
    }
    
}
