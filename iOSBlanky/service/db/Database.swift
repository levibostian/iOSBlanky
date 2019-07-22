//
//  Database.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/20/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

// Collection of DAOs so soemone needing to use 1+ DAOs have access to them all easily.
class Database {

    let repositoryDao: RepositoryDao

    init(repositoryDao: RepositoryDao) {
        self.repositoryDao = repositoryDao
    }

}
