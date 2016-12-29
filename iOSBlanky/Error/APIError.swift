//
//  APIError.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

enum APIError: Error {
    case apiNoResponseError
    case encodingParametersForUpload
    
    var error: NSError {
        switch self {
        case .apiNoResponseError: return BaseError.generateNSError(code: -1)
        case .encodingParametersForUpload: return BaseError.generateNSError(code: -2)
        }
    }
    
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .apiNoResponseError:
            return "API request returned no response."
        case .encodingParametersForUpload:
            return "Error encoding parameters for upload"
        }
    }
}
