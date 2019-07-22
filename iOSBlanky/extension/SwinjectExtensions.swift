//
//  SwinjectExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/20/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import Swinject

extension ServiceEntry {

    func singleton() {
        self.inObjectScope(.container)
    }

}
