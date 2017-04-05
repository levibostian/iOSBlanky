//
//  DateExtensions.swift
//  Pods
//
//  Created by Levi Bostian on 4/4/17.
//
//

import Foundation

public extension Date {
    
    func getIntTimeInverval() -> Int {
        return Int(timeIntervalSince1970)
    }
    
}
