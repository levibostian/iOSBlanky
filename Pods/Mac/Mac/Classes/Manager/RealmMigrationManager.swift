//
//  RealmMigrationManager.swift
//  Pods
//
//  Created by Levi Bostian on 4/4/17.
//
//

import Foundation
import RealmSwift

public protocol RealmMigrationManager {
    
    func getCurrentSchemaVersion() -> UInt64 
    func versionChange(versionToMigrateTo: UInt64, schema: Migration)
    
}
