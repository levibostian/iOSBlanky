//
//  RoundedUIImageView.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation
import UIKit

public class RoundedUIImageView: UIImageView {
    
    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
        
//        if borderWidth > 0 {
//            layer.borderWidth = 0
            //            layer.borderColor = UIColor.clearColor
//        }
    }
    
    override public func prepareForInterfaceBuilder() {
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.95)
    }
    
}
