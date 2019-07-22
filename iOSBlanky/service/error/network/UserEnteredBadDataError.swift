//
//  UserEnteredBadDataError.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/21/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

/**
 A 403 HTTP response code.
 */
class UserEnteredBadDataError: LocalizedError {

    let message: String

    init(message: String) {
        self.message = message
    }

    var errorDescription: String? {
        return message
    }

}
