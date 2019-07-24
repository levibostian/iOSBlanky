//
//  PendingTasksFactory.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/24/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import Wendy

class AppPendingTasksFactory: PendingTasksFactory {

    func getTask(tag: String) -> PendingTask? {
        switch tag {
        default: fatalError("Forgot case for tag: \(tag)")
        }
    }

}
