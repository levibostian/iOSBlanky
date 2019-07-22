//
//  ResponseServerError.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/21/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

/**
 A 500...600 HTTP response code was returned from a network call.
 */
class ResponseServerError: LocalizedError {

    private let message: String

    var errorDescription: String? {
        return message
    }

    init(message: String) {
        self.message = message
    }
}
