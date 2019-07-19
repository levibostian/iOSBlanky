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
import Teller

class ReposDataSourceRequirements: OnlineRepositoryGetDataRequirements {

    let githubUsername: String
    var tag: OnlineRepositoryGetDataRequirements.Tag {
        return "Repos for GitHub username: \(githubUsername)"
    }

    init(githubUsername: String) {
        self.githubUsername = githubUsername
    }
}

enum ResposApiError: Error, LocalizedError {
    case usernameDoesNotExist(username: String)
    
    var errorDescription: String? {
        switch self {
        case .usernameDoesNotExist(let username):
            return "The GitHub username \(username) does not exist."// comment: "GitHub returned 404 which means user does not exist.")
        }
    }
}

class ReposDataSource: OnlineRepositoryDataSource {

    typealias Cache = [RepoModel]
    typealias GetDataRequirements = ReposDataSourceRequirements
    typealias FetchResult = [RepoModel]

    fileprivate let moyaProvider: MoyaProvider<MultiTarget>
    fileprivate let jsonAdapter: JsonAdapter

    convenience init() {
        self.init(moyaProvider: MoyaProvider<MultiTarget>(plugins: MoyaPluginProvider.getPlugins(getNetworkActivityPlugin: true)), jsonAdapter: SwiftJsonAdpter())
    }

    init(moyaProvider: MoyaProvider<MultiTarget>, jsonAdapter: JsonAdapter) {
        self.moyaProvider = moyaProvider
        self.jsonAdapter = jsonAdapter
    }

    func getRealm() -> Realm {
        return RealmInstanceManager.sharedInstance.getInstance()
    }
    func getDao(realm: Realm) -> RepositoryDao {
        return DaoInstanceUtil(realm: realm).repositoryDao
    }

    var maxAgeOfData: Period = Period(unit: 3, component: .day)

    func fetchFreshData(requirements: ReposDataSourceRequirements) -> Single<FetchResponse<[RepoModel]>> {
        return moyaProvider.rx.request(MultiTarget(GitHubService.getUserRepos(username: requirements.githubUsername)))
            .map({ (response: Response) -> FetchResponse<[RepoModel]> in
                if response.statusCode == 404 {
                    throw MoyaError.underlying(ResposApiError.usernameDoesNotExist(username: requirements.githubUsername), response)
                }
                return FetchResponse.success(data: self.jsonAdapter.fromJsonArray(response.data))
            })
    }

    func saveData(_ fetchedData: [RepoModel], requirements: ReposDataSourceRequirements) {
        let realm = self.getRealm()
        let allRepos = realm.objects(RepoModel.self)
        try! realm.write {
            realm.delete(allRepos)
            realm.add(fetchedData)
        }
    }

    func observeCachedData(requirements: ReposDataSourceRequirements) -> Observable<[RepoModel]> {
        return Observable.array(from: getDao(realm: getRealm()).getRepos())
    }

    func isDataEmpty(_ cache: [RepoModel], requirements: ReposDataSourceRequirements) -> Bool {
        return cache.isEmpty
    }
    
}

class ReposRepository: OnlineRepository<ReposDataSource> {

    convenience init() {
        self.init(dataSource: ReposDataSource())
    }

}
