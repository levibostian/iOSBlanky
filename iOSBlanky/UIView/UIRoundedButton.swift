//
//  UIRoundedButton.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import UIKit

class UIRoundedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = self.tintColor.CGColor
    }
    
}
