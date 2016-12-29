//
//  BaseDAO.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import RealmSwift

class BaseDao {
    
    func getRealm() -> Realm {
        return RealmManager.getRealm()
    }
    
    func writeToRealm(_ objects: [Object], onError: @escaping (_ message: String) -> Void, onComplete: @escaping () -> Void) {
        DispatchQueue.main.async {
            autoreleasepool {
                let realm = try! Realm() // swiftlint:disable:this force_try
                
                for object in objects {
                    do {
                        try realm.write({
                            realm.add(object, update: true)
                        })
                    } catch {
                        onError("Error saving data.")
                    }
                }
                
                onComplete()
            }
        }
    }
    
}
