//
//  UIStackViewExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/19/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { (view) in
            addArrangedSubview(view)
        }
    }

}
