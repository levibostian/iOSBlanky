//
//  NoScrollTableView.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation
import UIKit

public class NoScrollTableView: UITableView {
    
    override public var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }
    
}
