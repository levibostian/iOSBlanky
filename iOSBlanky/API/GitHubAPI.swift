//
//  GitHubAPI.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class GitHubAPI {
    
    enum Router: URLRequestConvertible {
        static let baseURL = "https://api.github.com"
        
        case GetUserRepos(String)
        
        var method: Alamofire.Method {
            switch self {
            case .GetUserRepos:
                return .GET
            }
        }
        
        var path: String {
            switch self {
            case .GetUserRepos(let githubUsername):
                return "/users/\(githubUsername)/repos"
            }
        }
        
        var URLRequest: NSMutableURLRequest {
            let URL = NSURL(string: Router.baseURL)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            
            switch self {
            default:
                return mutableURLRequest
            }
        }
    }
    
    class func getUserRepos(gitHubUsername: String, onError: (message: String) -> Void, onComplete: (data: [RepoModel]?) -> Void) {
        apiCall(Router.GetUserRepos(gitHubUsername), onComplete: onComplete, onError: onError, errorMessage: "Error retrieving GitHub user repos. Try again later.")
    }
    
    private class func apiCall<DATA: Mappable>(call: Router, onComplete: (data: [DATA]?) -> Void, onError: (message: String) -> Void, errorMessage: String) {
        Alamofire.request(call)
            .responseArray { (response: Response<[DATA], NSError>) in
                // can check: response.response.statusCode to check response.
                switch response.result {
                case .Success:
                    onComplete(data: response.result.value)
                case .Failure:
                    onError(message: errorMessage)
                }
        }
    }
    
}
