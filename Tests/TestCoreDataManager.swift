@testable import App
import CoreData
import Foundation

class TestCoreDataManager: CoreDataManager {
    static var sharedMom: NSManagedObjectModel = {
        let modelURL = Bundle(for: AppCoreDataManager.self).url(forResource: AppCoreDataManager.nameOfModelFile, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    let persistentContainerQueue = OperationQueue() // make a queue for performing write operations to avoid conflicts with multiple writes at the same time from different contexts.
    static let nameOfModelFile = AppCoreDataManager.nameOfModelFile
    private let threadUtil: ThreadUtil = AppThreadUtil()

    private let persistentContainer: NSPersistentContainer

    init() {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: AppCoreDataManager.nameOfModelFile, managedObjectModel: TestCoreDataManager.sharedMom)

        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        self.persistentContainer = container

//        mom.entities.forEach { (description) in
//            print("[COREDATA] entity: \(description.name!)")
//        }
//
//        self.persistentContainer.managedObjectModel.entities.forEach { (des) in
//            print("[COREDATA] container entity: \(des.name!)")
//        }
    }

    lazy var uiContext: NSManagedObjectContext = {
        threadUtil.assertMain() // we are checking for main, just like in the App version of CoreDataManager because we want the app tests to behave as close to the App version as possible.

        return persistentContainer.viewContext
    }()

    // Mostly used for testing. *unsafe* means that we are not checking what thread you are on.
    lazy var unsafeContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    // Used by test functions. It is a way to write synchronous write operations making writing tests easier
    // this works because when using `.newBackgroundContext()`, it uses a concurrent type to it. We use the non-concurrent context and a performAndWait function to make sure everything runs synchronously.
    func performSyncOperation(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = unsafeContext

        context.performAndWait {
            block(context)
        }
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    func asyncWrite(_ block: @escaping (CDContext) -> Void) {
        persistentContainerQueue.addOperation {
            self.persistentContainer.performBackgroundTask { context in
                block(context)
                // We used to have `try! context.save()` here to automatically save. But, we shouldn't because saving can fail. So, require the caller of this function to handle when an error happens.
            }
        }
    }

    func reset(completionHandler: @escaping (Error?) -> Void) {
        // don't do anything. We load the store on init for in-memory stores.
        completionHandler(nil)
    }

    func loadStore(completionHandler: @escaping (Error?) -> Void) {
        // don't do anything. We load the store on init for in-memory stores.
        completionHandler(nil)
    }
}
