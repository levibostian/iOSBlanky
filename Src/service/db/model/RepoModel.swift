import CoreData
import Foundation

// @objc(CycleModel) // comment this out to prevent error "Failed to find a unique match for NSEntityDescription to a managed object subclass
class RepoModel: CDModel {
    @NSManaged var fullName: String?
    @NSManaged var repoDescription: String?
    // If you need to use an Int in your model, use Int16, Int32, or whatever as the @NSManaged var. Then, in `insertFrom()` and `toRepo()`, do the conversion to/from a regular Int. We like to handle VOs as much as possible in the app anyway so that works better.

    // If you have a relationship, you can add a property for that.
//    @NSManaged var tasks: [ToDoListTaskModel]?

    @nonobjc class func fetchRequest() -> NSFetchRequest<RepoModel> {
        NSFetchRequest<RepoModel>(entityName: name)
    }
}

extension RepoModel {
    static var name: String {
        "RepoModel"
    }

    class func insertFrom(_ repo: Repo, context: NSManagedObjectContext) -> RepoModel {
//        let model = RepoModel(entity: NSEntityDescription.entity(forEntityName: RepoModel.name, in: context)!, insertInto: context)
        let model = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! RepoModel // swiftlint:disable:this force_cast

        model.fullName = repo.fullName
        model.repoDescription = repo.repoDescription

        return model
    }

    func toRepo() -> Repo {
        Repo(fullName: fullName!,
             repoDescription: repoDescription)
    }
}
