//
//  BaseMacDataManager.swift
//  Pods
//
//  Created by Levi Bostian on 4/4/17.
//
//

import Foundation
import RealmSwift
import RxSwift
import iOSBoilerplate

open class BaseMacDataManager {
    
    public init() {
    }
    
    public func performRealmTransaction(changeData: @escaping ((Realm) -> Void), tempRealmInstance: Bool = false) {
        if Thread.isMainThread {
            fatalError("Cannot perform transaction from UI thread.")
        }
        
        let realm = getRealmInstance(tempInstance: tempRealmInstance)
        try! realm.writeIfNotAlready {
            changeData(realm)
        }
    }
    
    private func getRealmInstance(tempInstance: Bool) -> Realm {
        return tempInstance ? RealmInstanceManager.sharedInstance.getTempInstance() : RealmInstanceManager.sharedInstance.getInstance()
    }
    
    public func performRealmTransactionCompletable(changeData: @escaping ((Realm) -> Void), tempRealmInstance: Bool = false) -> Completable {
        return Completable.create(subscribe: { (observer) -> Disposable in
            if Thread.isMainThread {
                fatalError("Cannot perform transaction from UI thread.")
            }
            
            let realm = self.getRealmInstance(tempInstance: tempRealmInstance)
            try! realm.write {
                changeData(realm)
            }
            observer(CompletableEvent.completed)
            return Disposables.create()
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    public func getNewRealmId() -> String {
        return UUID().uuidString
    }
    
    public func createData<MODEL, PENDING_API_TASK>(realm: Realm, data: inout MODEL, makeAdditionalRealmChanges: (MODEL) -> Void, pendingApiTasks: [PENDING_API_TASK]) where MODEL: OfflineCapableModel, PENDING_API_TASK: PendingApiTask {
        realm.add(data as! Object, update: false) // we don't want to update. We want the call to FAIL. Why? Because we should be calling updateData() instead of create if you already have data with the same primary key in the realm.
            
        makeAdditionalRealmChanges(data)
        
        pendingApiTasks.forEach { (task: PENDING_API_TASK) in
            realm.add(task as! Object)
        }
        
        data.numberPendingApiSyncs += 1
    }
    
    // in future, make the pendingApiTask have have an interface for updating. We want to make sure that
    // only create, update, delete pending API models are calling the appropriate methods.
    public func updateData<MODEL, PENDING_API_TASK>(realm: Realm, modelClass: MODEL.Type, realmId: String, updateValues: (MODEL) -> Void, pendingApiTask: PENDING_API_TASK) where MODEL: Object, MODEL: OfflineCapableModel, PENDING_API_TASK: Object, PENDING_API_TASK: PendingApiTask {
        guard var modelToUpdateValues = realm.objects(modelClass).filter(NSPredicate(format: "realmId == %@", realmId)).first else {
            fatalError("\(modelClass.className()) model to update is null. Cannot find it in Realm.")
        }
        
        updateValues(modelToUpdateValues)
        
        let existingPendingApiTask = pendingApiTask.queryForExistingTask(realm: realm)
        if existingPendingApiTask == nil {
            modelToUpdateValues.numberPendingApiSyncs += 1
        }
        realm.add(pendingApiTask, update: true) // updates created_at value which tells pending API task runner to run *another* update on the model.
    }
//    
//    // in future, make the pendingApiTask have have an interface for updating. We want to make sure that
//    // only create, update, delete pending API models are calling the appropriate methods.
//    public func updateData<MODEL, PENDING_API_TASK>(realm: Realm, modelClass: MODEL.Type, realmId: String, updateValues: (MODEL) -> Void, pendingApiTasks: [PENDING_API_TASK]) where MODEL: OfflineCapableModel, PENDING_API_TASK: Object, PENDING_API_TASK: PendingApiTask {
//        guard modelClass is Object.Type else {
//            fatalError("modelClass param must be instance of Object")
//        }
//        
//        guard var modelToUpdateValues = (realm.objects(modelClass as! Object.Type).filter(NSPredicate(format: "realmId == %@", realmId)).first as? MODEL?) else {
//            fatalError("\((modelClass as! Object.Type).className()) model to update is null. Cannot find it in Realm.")
//        }
//        
//        updateValues(modelToUpdateValues!)
//        
//        pendingApiTasks.forEach { (task: PENDING_API_TASK) in
//            let existingPendingApiTask = task.queryForExistingTask(realm: realm)
//            if existingPendingApiTask == nil {
//                modelToUpdateValues!.numberPendingApiSyncs += 1
//            }
//            realm.add(task, update: true) // updates created_at value which tells pending API task runner to run *another* update on the model.
//        }
//    }
    
    public func deleteData<MODEL, PENDING_API_TASK>(realm: Realm, modelClass: MODEL.Type, realmId: String, updateValues: ((MODEL) -> Void), pendingApiTask: PENDING_API_TASK? = nil) where MODEL: Object, MODEL: OfflineCapableModel, PENDING_API_TASK: Object, PENDING_API_TASK: PendingApiTask {
        guard var modelToUpdateValues = realm.objects(modelClass).filter(NSPredicate(format: "realmId == %@", realmId)).first else {
            fatalError("\(modelClass.className()) model to update is null. Cannot find it in Realm.")
        }
        
        modelToUpdateValues.deleted = true
        updateValues(modelToUpdateValues)
        
        if let pendingApiTask = pendingApiTask {
            if let _ = pendingApiTask.queryForExistingTask(realm: realm) {
                modelToUpdateValues.numberPendingApiSyncs += 1
            }
            realm.add(pendingApiTask, update: true) // updates created_at value which tells pending API task runner to run *another* update on the model.
        }
    }
    
    public func undoDeleteData<MODEL>(realm: Realm, modelClass: MODEL.Type, realmId: String, updateValues: (MODEL) -> Void) where MODEL: Object, MODEL: OfflineCapableModel {
        guard var modelToUpdateValues = realm.objects(modelClass).filter(NSPredicate(format: "realmId == %@", realmId)).first else {
            fatalError("\(modelClass.className()) model to update is null. Cannot find it in Realm.")
        }
        
        modelToUpdateValues.deleted = false
        updateValues(modelToUpdateValues)
    }
    
}
