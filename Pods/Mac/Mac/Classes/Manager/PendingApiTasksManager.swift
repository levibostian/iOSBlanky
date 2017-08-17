//
//  PendingApiTasksManager.swift
//  Pods
//
//  Created by Levi Bostian on 4/3/17.
//
//

import Foundation

public class PendingApiTasksManager {
    
    internal static var pendingApiTaskTypes: [PendingApiTask.Type] = []
    
    public class func registerPendingApiTasks(types: [PendingApiTask.Type]) {
        self.pendingApiTaskTypes = types
    }
    
}
