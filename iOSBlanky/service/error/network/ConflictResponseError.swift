//
//  ConflictResponseError.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/21/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

enum ErrorIdType {
    case phoneNumberTaken
}

/**
 HTTP response code was 409
 */
struct ConflictResponseError: Codable {

    let message: String
    let errorId: String

    var errorIdType: ErrorIdType? {
        switch self.errorId {
        case "phone-number-taken":
            return .phoneNumberTaken
        default: fatalError("forgot case for: \(self.errorId)")
        }
    }

}

extension ConflictResponseError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
