import CoreData
import Foundation

enum CoreDataManagerStorageType {
    case inMemory
    case sqlite

    var type: String {
        switch self {
        case .inMemory: return NSInMemoryStoreType
        case .sqlite: return NSSQLiteStoreType
        }
    }
}

// sourcery: InjectRegister = "CoreDataManager"
// sourcery: InjectSingleton
class CoreDataManager {
    public static var shared: CoreDataManager = CoreDataManager()

    let persistentContainerQueue = OperationQueue() // make a queue for performing write operations to avoid conflicts with multiple writes at the same time from different contexts.
    let nameOfModelFile = "Model" // The name of the .xcdatamodeld file you want to use.
    private let threadUtil: ThreadUtil = AppThreadUtil()

    // Note: Must call `loadStore()` to initialize. Do not forget to do that.
    init() {
        persistentContainerQueue.maxConcurrentOperationCount = 1

        if let storeURL = self.storeURL {
            let description = storeDescription(with: storeURL)
            persistentContainer.persistentStoreDescriptions = [description]
        }
    }

    static func initTesting() -> CoreDataManager {
        let manager = CoreDataManager()

        if let storeURL = manager.storeURL {
            let description = manager.storeDescription(with: storeURL)

            description.shouldAddStoreAsynchronously = false
            description.type = CoreDataManagerStorageType.inMemory.type
            manager.persistentContainer.persistentStoreDescriptions = [description]

            manager.loadStore(completionHandler: nil)
        }

        return manager
    }

    // Perform read operations on UI thread
    var uiContext: NSManagedObjectContext {
        threadUtil.assertMain()

        return persistentContainer.viewContext
    }

    // Perform write operation on UI thread.
    func performBackgroundTaskOnUI(_ block: @escaping (NSManagedObjectContext) -> Void) {
        threadUtil.assertMain()

        persistentContainerQueue.addOperation {
            self.persistentContainer.performBackgroundTask { context in
                block(context)
                try! context.save()
            }
        }
    }

    // Perform write operations on background thread
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        threadUtil.assertBackground()

        persistentContainerQueue.addOperation {
            let context: NSManagedObjectContext = self.persistentContainer.newBackgroundContext()
            context.performAndWait {
                block(context)
                try! context.save()
            }
        }
    }

    /// The `URL` of the persistent store for this Core Data Stack. If there
    /// is more than one store this property returns the first store it finds.
    /// The store may not yet exist. It will be created at this URL by default
    /// when first loaded.
    var storeURL: URL? {
        var url: URL?
        let descriptions = persistentContainer.persistentStoreDescriptions
        if let firstDescription = descriptions.first {
            url = firstDescription.url
        }
        return url
    }

    /// Destroy a persistent store.
    ///
    /// - Parameter storeURL: An `NSURL` for the persistent store to be
    ///   destroyed.
    /// - Returns: A flag indicating if the operation was successful.
    /// - Throws: If the store cannot be destroyed.
    func destroyPersistentStore(at storeURL: URL) throws {
        let psc = persistentContainer.persistentStoreCoordinator
        try psc.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
    }

    /// Replace a persistent store.
    ///
    /// - Parameter destinationURL: An `NSURL` for the persistent store to be
    ///   replaced.
    /// - Parameter sourceURL: An `NSURL` for the source persistent store.
    /// - Returns: A flag indicating if the operation was successful.
    /// - Throws: If the persistent store cannot be replaced.
    func replacePersistentStore(at url: URL, withPersistentStoreFrom sourceURL: URL) throws {
        let psc = persistentContainer.persistentStoreCoordinator
        try psc.replacePersistentStore(at: url, destinationOptions: nil,
                                       withPersistentStoreFrom: sourceURL, sourceOptions: nil, ofType: NSSQLiteStoreType)
    }

    /// A read-only flag indicating if the persistent store is loaded.
    public private(set) var isStoreLoaded = false

    // Note: Meant to be called from UI thread as completionHandler will be called to Ui thread.
    func loadStore(completionHandler: ((Error?) -> Void)?) {
        persistentContainer.loadPersistentStores { _, error in
            if error == nil {
                self.isStoreLoaded = true
                self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
                self.persistentContainer.viewContext.shouldDeleteInaccessibleFaults = true
            } else {
                if completionHandler == nil {
                    fatalError("Error: \(error!)")
                }
            }

            DispatchQueue.main.async {
                completionHandler?(error)
            }
        }
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(for: CoreDataManager.self)
        let mom = NSManagedObjectModel.mergedModel(from: [bundle])!

        return NSPersistentContainer(name: nameOfModelFile, managedObjectModel: mom)
    }()

    private func storeDescription(with url: URL) -> NSPersistentStoreDescription {
        let description = NSPersistentStoreDescription(url: url)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        description.shouldAddStoreAsynchronously = true
        description.isReadOnly = false
        description.type = CoreDataManagerStorageType.sqlite.type
        return description
    }
}
