import CoreData
import Foundation

class RepoModel: NSManagedObject {
    @NSManaged var fullName: String?
    @NSManaged var repoDescription: String?

    @nonobjc class func fetchRequest() -> NSFetchRequest<RepoModel> {
        return NSFetchRequest<RepoModel>(entityName: "RepoModel")
    }
}

extension RepoModel {
    class func insertFrom(_ repo: Repo, context: NSManagedObjectContext) -> RepoModel {
        let model = RepoModel(context: context)

        model.fullName = repo.fullName
        model.repoDescription = repo.repoDescription

        return model
    }

    func toRepo() -> Repo {
        return Repo(fullName: fullName!,
                    repoDescription: repoDescription)
    }
}
