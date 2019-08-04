import CoreData
import Foundation
import RxCoreData
import RxSwift
import UIKit

class RepositoryDao {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func replaceRepos(_ repos: [Repo], forUsername: GitHubUsername) {
        coreDataManager.performBackgroundTask { context in
            repos.forEach { repo in
                _ = RepoModel.insertFrom(repo, context: context)
            }

            try! context.save()
        }
    }

    func observeRepos(forUsername username: GitHubUsername) -> Observable<[Repo]> {
        let pendingTaskFetchRequest: NSFetchRequest<RepoModel> = RepoModel.fetchRequest()
        pendingTaskFetchRequest.predicate = NSPredicate(format: "fullName BEGINSWITH %@", username)
        pendingTaskFetchRequest.sortDescriptors = [NSSortDescriptor(key: "fullName", ascending: true)]

        return coreDataManager.uiContext.rx.entities(fetchRequest: pendingTaskFetchRequest).map { (repoModels) -> [Repo] in
            repoModels.map { (repoModel) -> Repo in
                repoModel.toRepo()
            }
        }
    }
}
