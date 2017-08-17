//
//  MacProcessApiResponse.swift
//  Pods
//
//  Created by Levi Bostian on 4/3/17.
//
//

import Foundation
import Alamofire

public protocol MacProcessApiResponse {
    
    func success(rawResponse: DataResponse<Any>, responseBody: Any?, headers: [AnyHashable : Any])
    func error(error: Error?, statusCode: Int?, rawResponse: DataResponse<Any>, responseBody: Any?, headers: [AnyHashable : Any]?) -> Error?
    
}
