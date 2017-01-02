//
//  UICheckBox.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation
import UIKit

public class UICheckBox: UIButton {
    
    public var checked: Bool! {
        didSet {
            setCheckedImage()
        }
    }
    let checkboxCheckedRes = "checkbox_checked.png"
    let checkboxUncheckedRes = "checkbox_unchecked.png"
    
    public func setCheckedImage() {
        if self.checked == false {
            self.setImage(UIImage(named: checkboxUncheckedRes)!, for: UIControlState())
        } else {
            self.setImage(UIImage(named: checkboxCheckedRes)!, for: UIControlState())
        }
    }
    
    public func checkBoxClicked() {
        self.checked = !self.checked
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customInit()
    }
    
    fileprivate func customInit() {
        self.contentHorizontalAlignment = .left
        
        checked = false
        self.addTarget(self, action: #selector(self.checkBoxClicked), for: .touchUpInside)
    }
    
}
