import CoreData
import Foundation

class RepoModel: NSManagedObject {
    @NSManaged var fullName: String?
    @NSManaged var repoDescription: String?

    @nonobjc class func fetchRequest() -> NSFetchRequest<RepoModel> {
        NSFetchRequest<RepoModel>(entityName: name)
    }
}

extension RepoModel {
    static var name: String {
        "RepoModel"
    }

    class func insertFrom(_ repo: Repo, context: NSManagedObjectContext) -> RepoModel {
        let model = RepoModel(context: context)

        model.fullName = repo.fullName
        model.repoDescription = repo.repoDescription

        return model
    }

    func toRepo() -> Repo {
        Repo(fullName: fullName!,
             repoDescription: repoDescription)
    }
}
