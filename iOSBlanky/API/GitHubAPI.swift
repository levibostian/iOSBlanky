//
//  GitHubAPI.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class GitHubAPI: BaseApi {
    
    enum Router: URLRequestConvertible {
        case getUserRepos(username: String)
        
        var method: HTTPMethod {
            switch self {
            case .getUserRepos:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .getUserRepos(let username):
                return "/users/\(username)/repos"
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            let url = try BaseApi.baseURL.asURL()
            
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            
//            do {
//                if try UserCredsManager.areUserCredsAvailable() {
//                    urlRequest.setValue(try UserCredsManager.getAuthToken(), forHTTPHeaderField: "Access-Token")
//                }
//            } catch {
//                LogUtil.logError(APIError.gettingUserCredentials.error)
//            }
            
//            let encodeParameters = { (parameters: Parameters) -> Void in
//                urlRequest = try URLEncoding.methodDependent.encode(urlRequest, with: parameters)
//            }
            
            switch self {
//            case .loginToApp(let parameters):
//                try encodeParameters(parameters)
//            case .editProfile(_, let parameters):
//                try encodeParameters(parameters)
            default:
                break
            }
            
            return urlRequest
        }
    }
    
    class func getUserRepos(gitHubUsername: String, onError: @escaping (_ message: String) -> Void, onComplete: @escaping (_ data: [RepoModel]?) -> Void) {
        BaseApi.apiCallArray(call: Router.getUserRepos(username: gitHubUsername), onComplete: onComplete, onError: onError, errorMessage: "Error retrieving GitHub user repos. Try again later.", errorVo: ErrorVo())
    }
    
}
