//
//  RealmInstanceManager.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/28/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmInstanceManager: NSObject {
    
    public static let sharedInstance = RealmInstanceManager()
    
    public func getTempInstance() -> Realm {
        return try! Realm(configuration: getInMemoryConfiguration())
    }
    
    public func getInstance() -> Realm {
        return try! Realm(configuration: getConfiguration())
    }
    
    private override init() {
    }
    
    private func getInMemoryConfiguration() -> Realm.Configuration {
        var configuration = Realm.Configuration()
        configuration.inMemoryIdentifier = "InMemory"
        return configuration
    }
    
    private func getConfiguration() -> Realm.Configuration {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        var nameOfDocument = "default"
        if let userId = UserManager.userId { nameOfDocument = String(userId) }
        let url = documentDirectory.appendingPathComponent("\(nameOfDocument).realm")
        var config = Realm.Configuration()
        config.fileURL = url
        config.schemaVersion = 0
        config.migrationBlock = { migration, oldSchemaVersion in
            //for version in oldSchemaVersion...config.schemaVersion {
                // if version == 0 { }
            //}
        }
        
        return config
    }
    
}
