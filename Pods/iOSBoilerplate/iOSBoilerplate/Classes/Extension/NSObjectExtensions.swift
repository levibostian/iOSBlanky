//
//  NSObjectExtensions.swift
//  Pods
//
//  Created by Levi Bostian on 4/4/17.
//
//

import Foundation

public extension NSObject {
    
    /// Provides thread-safe access to given object
    func synchronizedBlock(lockedObject: AnyObject, accessLockedObject: () -> Void) {
        objc_sync_enter(lockedObject)
        accessLockedObject()
        objc_sync_exit(lockedObject)
    }
    
}
