import CoreData
import Foundation

class RepositoryDao {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func replaceRepos(_ repos: [Repo], forUsername: GitHubUsername) {
        coreDataManager.performBackgroundTask { context in
            let existingReposFetch: NSFetchRequest<NSFetchRequestResult> = RepoModel.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: existingReposFetch)
            try! context.execute(batchDeleteRequest)

            repos.forEach { repo in
                _ = RepoModel.insertFrom(repo, context: context)
            }

            try! context.save()
        }
    }

    func getRepos(forUsername: GitHubUsername) -> [Repo] {
        let pendingTaskFetchRequest: NSFetchRequest<RepoModel> = RepoModel.fetchRequest()
        pendingTaskFetchRequest.predicate = NSPredicate(format: "fullName == %@", forUsername)

        return try! coreDataManager.uiContext.fetch(pendingTaskFetchRequest).map { (repoModel) -> Repo in
            repoModel.toRepo()
        }
    }
}
