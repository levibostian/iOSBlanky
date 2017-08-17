//
//  AndroidRealmConfig.swift
//  Pods
//
//  Created by Levi Bostian on 4/4/17.
//
//

import Foundation

public class iOSRealmConfigBuilder {
    
    public var realmInstanceConfig: RealmInstanceConfig?
    public var migrationManager: RealmMigrationManager?
    
    public typealias BuilderClosure = (iOSRealmConfigBuilder) -> ()
    
    public init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
    
}

internal var iOSRealmConfigInstance: iOSRealmConfig? = nil
public struct iOSRealmConfig {
    
    public var realmInstanceConfig: RealmInstanceConfig?
    public var migrationManager: RealmMigrationManager?
    
    public init?(builder: iOSRealmConfigBuilder) {
        if let instanceConfig = builder.realmInstanceConfig, let migrationManager = builder.migrationManager {
            self.realmInstanceConfig = instanceConfig
            self.migrationManager = migrationManager
            
            iOSRealmConfigInstance = self
        } else {
            return nil
        }
    }
    
}
