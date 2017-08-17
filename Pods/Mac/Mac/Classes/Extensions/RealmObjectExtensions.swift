//
//  RealmObjectExtensions.swift
//  Pods
//
//  Created by Levi Bostian on 4/4/17.
//
//

import Foundation
import RealmSwift

public extension Object {
    
    func isManaged() -> Bool {
        return realm != nil
    }
    
}
