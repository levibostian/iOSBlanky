//
//  RealmManager.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    fileprivate static var realm: Realm?
    
    class func getRealm() -> Realm {
        if realm == nil {
            realm = try! Realm() // swiftlint:disable:this force_try
        }
        
        return realm!
    }
    
    class func deleteRealm() {
        let realm = getRealm()
        
        try! realm.write { // swiftlint:disable:this force_try
            realm.deleteAll()
        }
    }
    
}
