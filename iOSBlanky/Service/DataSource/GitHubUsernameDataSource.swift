//
//  GitHubUsernameDataSource.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/28/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias GitHubUsername = String

class GitHubUsernameDataSource: BaseLocalDataSource<GitHubUsername> {
    
    fileprivate let githubUsernameUserDefaultsKey = "githubUsernameUserDefaultsKey"
    
    override func saveData(_ data: GitHubUsername?) {
        UserDefaults.standard.set(data, forKey: self.githubUsernameUserDefaultsKey)
    }
    
    override func observeLocalData() -> Observable<GitHubUsername> {
        return UserDefaults.standard.rx.observe(String.self, githubUsernameUserDefaultsKey)
            .map({ (username: String?) -> String in
                guard let username = username else { return "" }
                return username
            })
    }
    
    override func isDataEmpty(_ data: GitHubUsername) -> Bool {
        return data.characters.count <= 0
    }
    
    override func getValue() -> GitHubUsername? {
        return UserDefaults.standard.string(forKey: githubUsernameUserDefaultsKey)
    }
    
}
