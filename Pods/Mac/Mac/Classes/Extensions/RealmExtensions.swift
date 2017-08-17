//
//  RealmExtensions.swift
//  Pods
//
//  Created by Levi Bostian on 4/25/17.
//
//

import Foundation
import RealmSwift

public extension Realm {
    
    func writeIfNotAlready(_ block: () throws -> Void) throws {
        if !isInWriteTransaction {
            try write(block)
        } else {
            try block()
        }
    }
    
}
