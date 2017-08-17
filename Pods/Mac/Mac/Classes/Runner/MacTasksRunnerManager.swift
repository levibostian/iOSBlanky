//
//  MacTasksRunnerManager.swift
//  Pods
//
//  Created by Levi Bostian on 4/3/17.
//
//

import Foundation

public protocol MacTasksRunnerManager {
    
    func shouldRunApiTasks() -> Bool
    func doneRunningTasks(tempInstance: Bool)
    func errorRunningTasks(tempInstance: Bool, error: Error)
    
    func doneRunningSingleTask(pendingApiTask: PendingApiTask)
    func errorRunningSingleTask(pendingApiTask: PendingApiTask, error: Error)
    
}
