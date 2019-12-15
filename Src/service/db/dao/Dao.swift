import CoreData
import Foundation

protocol Dao {
    var modelName: String { get }
    var coreDataManager: CoreDataManager { get }
}

extension Dao {
    func deleteAll(onComplete: @escaping OnComplete) {
        coreDataManager.performBackgroundTask { context in
            let fetchAll = NSFetchRequest<NSFetchRequestResult>(entityName: self.modelName)
            let request = NSBatchDeleteRequest(fetchRequest: fetchAll)
            try! context.execute(request)
            try! context.save()

            onComplete()
        }
    }
}
