//
//  StringExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

extension String {
    
    func get(_ index: Int) -> String {
        return self.substring(to: self.index(startIndex, offsetBy: index))
    }
    
}
