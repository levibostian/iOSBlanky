//
//  ErrorVo.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 4/5/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation

class DefaultErrorVo {
    
    var errors: [String] = []
    
    func getErrorMessageToDisplayToUser() -> String {
        return errors[0]
    }
    
}
