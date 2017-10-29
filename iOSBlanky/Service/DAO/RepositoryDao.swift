//
//  RepositoryDao.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/28/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import RealmSwift

class RepositoryDao {
    
    fileprivate var realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func getRepos() -> Results<RepoModel> {
        return self.realm.objects(RepoModel.self)
    }
    
}
