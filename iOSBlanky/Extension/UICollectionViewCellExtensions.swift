//
//  UICollectionViewCellExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    
    func addBorder(_ width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func removeBorder() {
        layer.borderWidth = 0
    }
    
}
