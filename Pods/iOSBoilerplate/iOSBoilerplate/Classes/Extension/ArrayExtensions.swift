//
//  ArrayExtensions.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation

public extension Array where Element:Equatable {
    
    public func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
    
}
