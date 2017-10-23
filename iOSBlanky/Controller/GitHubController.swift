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

class GitHubController: Controller {
    
    private static var instance: GitHubController?
    private let disposeBag = DisposeBag()
    
    internal static func getInstance() -> GitHubController {
        if instance == nil {
            instance = GitHubController()
        }
        
        return instance!
    }
    
    func getUserRepos(gitHubUsername: String, onError: @escaping (_ message: String) -> Void, onComplete: @escaping (_ data: [RepoModel]?) -> Void) {
        getMoyaProvider().rx.request(MultiTarget(GitHubService.getUserRepos(username: gitHubUsername)))
            .mapArray(RepoModel.self)
            .subscribe { event in
                switch event {
                case .success(let response):
                    NSLog("num repos %d", response.count)
                case .error(let error):
                    NSLog("error %@", error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
    
}
