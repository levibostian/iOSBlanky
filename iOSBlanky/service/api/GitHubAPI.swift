//
//  API.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/20/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol GitHubAPI {
    func getUserRepos(username: String) -> Single<Result<[Repo], Error>>
}

class AppGitHubApi: GitHubAPI {

    fileprivate let moyaProvider: MoyaInstance
    fileprivate let jsonAdapter: JsonAdapter
    fileprivate let responseProcessor: MoyaResponseProcessor

    init(moyaProvider: MoyaInstance, jsonAdapter: JsonAdapter, responseProcessor: MoyaResponseProcessor) {
        self.moyaProvider = moyaProvider
        self.jsonAdapter = jsonAdapter
        self.responseProcessor = responseProcessor
    }

    func getUserRepos(username: GitHubUsername) -> Single<Result<[Repo], Error>> {
        return moyaProvider.rx.request(MultiTarget(GitHubService.getUserRepos(username: username)))
            .map({ (response) -> ProcessedResponse in
                return self.responseProcessor.process(response, extraResponseHandling: { (statusCode) -> Error? in
                    if statusCode == 404 {
                        return ResposApiError.usernameDoesNotExist(username: username)
                    }
                    return nil
                })
            }).map({ (processedResponse) -> Result<[Repo], Error> in
                if let error = processedResponse.error {
                    return Result.failure(error)
                }
                return Result.success(self.jsonAdapter.fromJsonArray(processedResponse.response!.data))
            }).catchError({ (error) -> Single<Result<[Repo], Error>> in
                return Single.just(Result.failure(self.responseProcessor.process(error).error!))
            })
    }

}
