//
//  ErrorResponseVo.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import ObjectMapper

protocol ErrorResponseVo: Mappable {
    func getErrorMessageToDisplayToUser() -> String
}
