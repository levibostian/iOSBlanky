//
//  UICollectionViewExtensions.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation
import UIKit

public extension UICollectionViewCell {
    
    public func addBorder(_ width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    public func removeBorder() {
        layer.borderWidth = 0
    }
    
}
