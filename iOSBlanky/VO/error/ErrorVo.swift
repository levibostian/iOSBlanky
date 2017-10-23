//
//  ErrorVo.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 4/5/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import ObjectMapper

public class DefaultErrorVo {
    
    var errors: [String] = []
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func getErrorMessageToDisplayToUser() -> String {
        return errors[0]
    }
    
    public func mapping(map: Map) {
        errors <- map["errors"]
    }
    
}
