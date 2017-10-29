//
//  DaoInstanceUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/28/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import RealmSwift

class DaoInstanceUtil {
    
    fileprivate var realm: Realm

    let repositoryDao: RepositoryDao
    
    init(realm: Realm) {
        self.realm = realm
        self.repositoryDao = RepositoryDao(realm: realm)
    }
    
}
