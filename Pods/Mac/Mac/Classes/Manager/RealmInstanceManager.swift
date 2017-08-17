//
//  RealmInstanceManager.swift
//  Pods
//
//  Created by Levi Bostian on 4/3/17.
//
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
        let url = documentDirectory.appendingPathComponent("\(iOSRealmConfigInstance?.realmInstanceConfig?.getRealmInstanceName() ?? "default").realm")
        var config = Realm.Configuration()
        config.fileURL = url
        config.schemaVersion = iOSRealmConfigInstance?.migrationManager?.getCurrentSchemaVersion() ?? 0
        config.migrationBlock = { migration, oldSchemaVersion in
            for version in oldSchemaVersion...config.schemaVersion {
                iOSRealmConfigInstance?.migrationManager?.versionChange(versionToMigrateTo: version, schema: migration)
            }
        }
        
        return config
    }
    
}
