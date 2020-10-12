import CoreData
import Foundation
import RxCoreData
import RxSwift
import UIKit

// sourcery: InjectRegister = "RepositoryDao"
class RepositoryDao: BaseDao {
    static var modelName: String {
        RepoModel.name
    }

    init(coreDataManager: CoreDataManager, logger: ActivityLogger, threadUtil: ThreadUtil) {
        super.init(coreDataManager: coreDataManager, modelName: Self.modelName, logger: logger, threadUtil: threadUtil)
    }

    func replaceRepos(_ repos: [Repo], forUsername _: GitHubUsername) -> DaoWrite {
        getDaoWrite { context in
            repos.forEach { repo in
                _ = RepoModel.insertFrom(repo, context: context)
            }

            try context.save()
        }
    }

    func getRepos(forUsername username: GitHubUsername) -> DaoRead<RepoModel> {
        let request: CDFetchRequest<RepoModel> = RepoModel.fetchRequest()

        request.predicate = NSPredicate(format: "fullName BEGINSWITH %@", username)
        request.sortDescriptors = [NSSortDescriptor(key: "fullName", ascending: true)]

        return getDaoRead(request: request)
    }
}
