//
//  GitHubController.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/4/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Moya_ObjectMapper

class GitHubController: BaseController {
    
    private static var instance: GitHubController?
    private let disposeBag = DisposeBag()
    
    internal static func getInstance() -> GitHubController {
        if instance == nil {
            instance = GitHubController()
        }
        
        return instance!
    }
    
    func getUserRepos(gitHubUsername: String, onError: @escaping (_ message: String) -> Void, onComplete: @escaping (_ data: [RepoModel]?) -> Void) {
        GitHubService.serviceProvider().request(.getUserRepos(username: gitHubUsername))
            .mapObject(RepoModel.self)
            .subscribe { event in
            switch event {
            case .next(let response): break
            // do something with the data
            case .error(let error): break
            // handle the error
            default:
                break
            }
        }.addDisposableTo(disposeBag)
    }
    
}
