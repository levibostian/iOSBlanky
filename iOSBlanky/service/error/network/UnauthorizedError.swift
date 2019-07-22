//
//  UnauthorizedError.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/21/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

/**
 HTTP response code was 401.
 */
class UnauthorizedError: LocalizedError {

    private let message: String

    var errorDescription: String? {
        return message
    }

    init(message: String) {
        self.message = message
    }
}
