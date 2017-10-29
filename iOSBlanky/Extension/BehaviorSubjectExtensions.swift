//
//  BehaviorSubjectExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/24/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import RxSwift

extension BehaviorSubject {
    
    func hasValue() -> Bool {
        do {
            try _ = self.value()            
            return true
        } catch {
            return false
        }
    }
    
}
