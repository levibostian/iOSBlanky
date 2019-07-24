//
//  APITargetsExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/23/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import Moya

typealias MoyaInstance = MoyaProvider<MultiTarget>

extension Response {

    func isSucccessfulResponse() -> Bool {
        return statusCode >= 200 && statusCode < 300
    }

}
