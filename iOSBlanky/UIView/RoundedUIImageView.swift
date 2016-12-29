//
//  RoundedUIImageView.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import UIKit

class RoundedUIImageView: UIImageView {
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
        
        if borderWidth > 0 {
            layer.borderWidth = 0
            //            layer.borderColor = UIColor.clearColor
        }
    }
    
    override func prepareForInterfaceBuilder() {
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.95)
    }
    
}
