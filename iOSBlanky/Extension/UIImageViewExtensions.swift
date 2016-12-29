//
//  UIImageViewExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import UIKit 

extension UIImageView {
    
    func circularImage() {
        layer.borderWidth = 0
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = frame.size.height / 2
        clipsToBounds = true
    }
    
}
