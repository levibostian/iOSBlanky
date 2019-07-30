//
//  AppStartupUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/30/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

protocol StartupUtil {
    func runStartupTasks(_ onComplete: @escaping (Error?) -> Void)
}

class AppStartupUtil: StartupUtil {

    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func runStartupTasks(_ onComplete: @escaping (Error?) -> Void) {
        coreDataManager.loadStore { (error) in
            onComplete(error)
        }
    }

}
