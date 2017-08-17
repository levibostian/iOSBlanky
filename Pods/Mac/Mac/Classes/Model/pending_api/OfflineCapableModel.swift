//
//  PendingApiModelInterface.swift
//  Pods
//
//  Created by Levi Bostian on 4/3/17.
//
//

import Foundation

public protocol OfflineCapableModel {
    
    var realmId: String { get set }
    var apiId: Int { get set }
    var apiSyncInProgress: Bool { get set } // use in UI to show progress bar as model is syncing
    var numberPendingApiSyncs: Int { get set } // used for isPendingApiSync() to indicate if *all* service tasks for syncing this model are complete.
    var deleted: Bool { get set }
    
    func isPendingApiSync() -> Bool // use in UI to show that the model is not fully synced yet with API.
    
    func statusUpdate(task: PendingApiTask, status: OfflineCapableModelStatus, error: Error?)
    
}

public enum OfflineCapableModelStatus {
    case running
    case success
    case error 
}
