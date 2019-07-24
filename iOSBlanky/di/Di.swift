//
//  Container.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/17/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import Swinject
import Moya

class Di: ConvenientInject { // swiftlint:disable:this type_name

    static var inject: Di = Di()

    private let container = DiContainer()

    private init() {
    }

    var activityLogger: ActivityLogger {
        return container.inject(.activityLogger)
    }

    var reposViewModel: ReposViewModel {
        return container.inject(.reposViewModel)
    }

    var remoteConfig: RemoteConfigProvider {
        return container.inject(.remoteConfig)
    }

    var userManager: UserManager {
        return container.inject(.userManager)
    }

}

// Exists for when using
protocol ConvenientInject {
    var activityLogger: ActivityLogger { get }
    var reposViewModel: ReposViewModel { get }
    var remoteConfig: RemoteConfigProvider { get }
    var userManager: UserManager { get }
}

class DiContainer {

    fileprivate let container: Container = Container()

    init() {
        self.registerDependencies()
    }

    private func registerDependencies() {
        self.container.register(ActivityLogger.self) { _ in AppActivityLogger() }
        self.container.register(CoreDataManager.self) { _ in CoreDataManager() }.singleton()
        self.container.register(RepositoryDao.self) { container in
            RepositoryDao(coreDataManager: self.inject(.coreDataManager, container))
        }
        self.container.register(ReposDataSource.self) { container in
            ReposDataSource(githubApi: self.inject(.githubApi, container),
                            db: self.inject(.database, container))
        }
        self.container.register(ReposRepository.self) { container in
            ReposRepository(dataSource: self.inject(.reposDataSource, container))
        }
        self.container.register(ReposViewModel.self) { container in
            ReposViewModel(reposRepository: self.inject(.reposRepository, container),
                           githubUsernameRepository: self.inject(.githubUsernameRepository, container))
        }
        self.container.register(GitHubUsernameRepository.self) { container in
            GitHubUsernameRepository(dataSource: self.inject(.githubDataSource, container))
        }
        self.container.register(GitHubUsernameDataSource.self) { _ in
            GitHubUsernameDataSource()
        }
        self.container.register(MoyaInstance.self) { container in
            let productionPlugins: [PluginType] = [
                MoyaAppendHeadersPlugin(userCredsManager: self.inject(.userCredsManager, container)),
                HttpLoggerMoyaPlugin()]

            var plugins: [PluginType] = []
            plugins.append(contentsOf: productionPlugins)

            let networkActivityPlugin: NetworkActivityPlugin = NetworkActivityPlugin(networkActivityClosure: { (change, _) in
                switch change {
                case .began:
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    }
                case .ended:
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            })

            plugins.append(networkActivityPlugin)

            return MoyaProvider<MultiTarget>(plugins: plugins)
        }
        self.container.register(GitHubAPI.self) { container in
            AppGitHubApi(moyaProvider: self.inject(.moyaProvider, container),
                         jsonAdapter: self.inject(.jsonAdapter, container),
                         responseProcessor: self.inject(.moyaResponseProcessor, container))
        }
        self.container.register(JsonAdapter.self) { _ in
            SwiftJsonAdpter()
        }
        self.container.register(Database.self) { container in
            Database(repositoryDao: self.inject(.repositoryDao, container))
        }
        self.container.register(EventBus.self) { _ in
            NotificationCenterEventBus()
        }
        self.container.register(MoyaResponseProcessor.self) { container in
            MoyaResponseProcessor(jsonAdapter: self.inject(.jsonAdapter, container),
                                  activityLogger: self.inject(.activityLogger, container),
                                  eventBus: self.inject(.eventBus, container))
        }
        self.container.register(RemoteConfigProvider.self) { _ in
            FirebaseRemoteConfig()
        }
        self.container.register(UserManager.self) { _ in
            UserManager()
        }
        self.container.register(UserCredsManager.self) { container in
            UserCredsManager(userManager: self.inject(.userManager, container))
        }
    }

    func inject<T>(_ dep: Dependency) -> T {
        return inject(dep, self.container)
    }

    fileprivate func inject<T>(_ dep: Dependency, _ resolver: Resolver) -> T {
        return resolve(dep, resolver) as! T // swiftlint:disable:this force_cast
    }

    private func resolve(_ dep: Dependency, _ resolver: Resolver) -> Any {
        switch dep {
        case .activityLogger: return resolver.resolve(ActivityLogger.self)! as Any
        case .coreDataManager: return resolver.resolve(CoreDataManager.self)! as Any
        case .repositoryDao: return resolver.resolve(RepositoryDao.self)! as Any
        case .reposDataSource: return resolver.resolve(ReposDataSource.self)! as Any
        case .reposRepository: return resolver.resolve(ReposRepository.self)! as Any
        case .reposViewModel: return resolver.resolve(ReposViewModel.self)! as Any
        case .githubUsernameRepository: return resolver.resolve(GitHubUsernameRepository.self)! as Any
        case .githubDataSource: return resolver.resolve(GitHubUsernameDataSource.self)! as Any
        case .moyaProvider: return resolver.resolve(MoyaInstance.self)! as Any
        case .githubApi: return resolver.resolve(GitHubAPI.self)! as Any
        case .jsonAdapter: return resolver.resolve(JsonAdapter.self)! as Any
        case .database: return resolver.resolve(Database.self)! as Any
        case .eventBus: return resolver.resolve(EventBus.self)! as Any
        case .moyaResponseProcessor: return resolver.resolve(MoyaResponseProcessor.self)! as Any
        case .remoteConfig: return resolver.resolve(RemoteConfigProvider.self)! as Any
        case .userManager: return resolver.resolve(UserManager.self)! as Any
        case .userCredsManager: return resolver.resolve(UserCredsManager.self)! as Any
        }
    }

}
