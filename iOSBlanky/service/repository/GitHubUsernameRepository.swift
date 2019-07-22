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
import Teller

struct GitHubUsernameDataSourceRequirements: LocalRepositoryGetDataRequirements {
}

typealias GitHubUsername = String

class GitHubUsernameDataSource: LocalRepositoryDataSource {

    typealias Cache = GitHubUsername
    typealias GetDataRequirements = GitHubUsernameDataSourceRequirements

    var value: GitHubUsername? {
        return UserDefaults.standard.string(forKey: githubUsernameUserDefaultsKey)
    }
    
    fileprivate let githubUsernameUserDefaultsKey = "githubUsernameUserDefaultsKey"

    func saveData(data: GitHubUsername) {
        UserDefaults.standard.set(data, forKey: self.githubUsernameUserDefaultsKey)
    }

    func observeCachedData() -> Observable<GitHubUsername> {
        return UserDefaults.standard.rx.observe(String.self, githubUsernameUserDefaultsKey)
            .map({ (username: String?) -> String in
                guard let username = username else { return "" }
                return username
            })
    }

    func isDataEmpty(data: GitHubUsername) -> Bool {
        return data.count <= 0
    }
    
}

class GitHubUsernameRepository: LocalRepository<GitHubUsernameDataSource> {

    convenience init() {
        self.init(dataSource: GitHubUsernameDataSource())
    }

}
