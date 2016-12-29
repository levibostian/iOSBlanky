//
//  ErrorVo.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import ObjectMapper

class ErrorVo: ErrorResponseVo {
    
    var errors: [String] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func getErrorMessageToDisplayToUser() -> String {
        return errors[0]
    }
    
    func mapping(map: Map) {
        errors <- map["errors"]
    }
    
}
