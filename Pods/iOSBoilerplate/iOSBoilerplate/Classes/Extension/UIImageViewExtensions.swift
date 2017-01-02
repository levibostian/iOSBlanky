//
//  UIImageViewExtensions.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation
import UIKit

public extension UIImageView {
    
    public func circularImage() {
        layer.borderWidth = 0
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = frame.size.height / 2
        clipsToBounds = true
    }
    
}
