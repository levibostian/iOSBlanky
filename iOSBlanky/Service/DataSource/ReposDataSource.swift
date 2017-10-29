//
//  ReposDataSource.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/23/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm
import Moya
import Moya_ObjectMapper

class GetDataReposRequirements: GetDataRequirements {
    fileprivate var githubUsername: String
    
    init(githubUsername: String) {
        self.githubUsername = githubUsername
        self.description = "GetDataReposRequirements_\(githubUsername)"
    }
    
    var description: String
    
}

enum ResposApiError: Error, LocalizedError {
    case usernameDoesNotExist(username: String)
    
    public var errorDescription: String? {
        switch self {
        case .usernameDoesNotExist(let username):
            return "The GitHub username \(username) does not exist."// comment: "GitHub returned 404 which means user does not exist.")
        }
    }
}

class ReposDataSource: BaseOnlineDataSource<[RepoModel], GetDataReposRequirements, [RepoModel]> {
    
    func getRealm() -> Realm {
        return RealmInstanceManager.sharedInstance.getInstance()
    }
    func getDao(realm: Realm) -> RepositoryDao {
        return DaoInstanceUtil(realm: realm).repositoryDao
    }
    
    override func fetchFreshDataOrFail(requirements: GetDataReposRequirements) -> Single<[RepoModel]> {
        return moyaProvider.rx.request(MultiTarget(GitHubService.getUserRepos(username: requirements.githubUsername)))
            .map({ (response: Response) -> Response in
                if response.statusCode == 404 {
                    throw MoyaError.underlying(ResposApiError.usernameDoesNotExist(username: requirements.githubUsername), response)
                }
                return response
            })
            .mapArray(RepoModel.self)
    }
    
    override func saveData(_ data: [RepoModel]) -> Completable {
        return Completable.create(subscribe: { (observer) -> Disposable in
            let realm = self.getRealm()
            let allRepos = realm.objects(RepoModel.self)
            try! realm.write {
                realm.delete(allRepos)
                realm.add(data)
            }
            observer(CompletableEvent.completed)
            return Disposables.create()
        })
    }
    
    override func getCachedData(requirements: GetDataReposRequirements) -> Observable<[RepoModel]> {
        return Observable.array(from: getDao(realm: getRealm()).getRepos())
    }
    
    override func isDataEmpty(_ data: [RepoModel]) -> Bool {
        return data.isEmpty
    }
    
}

