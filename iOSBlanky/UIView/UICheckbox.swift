//
//  UICheckbox.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import UIKit

class UICheckBox: UIButton {
    
    var checked: Bool! {
        didSet {
            setCheckedImage()
        }
    }
    let checkboxCheckedRes = "checkbox_checked.png"
    let checkboxUncheckedRes = "checkbox_unchecked.png"
    
    func setCheckedImage() {
        if self.checked == false {
            self.setImage(UIImage(named: checkboxUncheckedRes)!, for: UIControlState())
        } else {
            self.setImage(UIImage(named: checkboxCheckedRes)!, for: UIControlState())
        }
    }
    
    func checkBoxClicked() {
        self.checked = !self.checked
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customInit()
    }
    
    func customInit() {
        self.contentHorizontalAlignment = .left
        
        checked = false
        self.addTarget(self, action: #selector(self.checkBoxClicked), for: .touchUpInside)
    }
    
}
