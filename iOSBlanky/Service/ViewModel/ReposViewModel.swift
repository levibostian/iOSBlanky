//
//  ReposViewModel.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/23/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import RxSwift

class ReposViewModel {
    
    fileprivate var reposDataSource: ReposDataSource
    fileprivate var githubUsernameDataSource: GitHubUsernameDataSource
    
    convenience init() {
        self.init(reposDataSource: ReposDataSource(), githubUsernameDataSource: GitHubUsernameDataSource())
    }
    
    init(reposDataSource: ReposDataSource, githubUsernameDataSource: GitHubUsernameDataSource) {
        self.reposDataSource = reposDataSource
        self.githubUsernameDataSource = githubUsernameDataSource
        
        if let existingGitHubUsername: GitHubUsername = githubUsernameDataSource.getValue() {
            reposDataSource.setDataQueryRequirements(GetDataReposRequirements(githubUsername: existingGitHubUsername))
        }
    }
    
    func setGitHubUsernameForRepos(_ username: String) {
        githubUsernameDataSource.saveData(username)
        reposDataSource.setDataQueryRequirements(GetDataReposRequirements(githubUsername: username))
    }
    
    func observeRepos() -> Observable<StateData<[RepoModel]>> {
        return reposDataSource.getObservableState()
    }
    
    func observeGitHubUsername() -> Observable<StateData<GitHubUsername>> {
        return githubUsernameDataSource.getObservableState()
    }
    
}
