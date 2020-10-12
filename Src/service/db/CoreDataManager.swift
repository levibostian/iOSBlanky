import CoreData
import Foundation

protocol CoreDataManager: AutoMockable {
    var uiContext: CDContext { get }
    func newBackgroundContext() -> CDContext // Use this context to perform synchronous write operations. make sure to call performAndWait{} on it!
    func asyncWrite(_ block: @escaping (CDContext) -> Void)
    func loadStore(completionHandler: @escaping (Error?) -> Void)
    func reset(completionHandler: @escaping (Error?) -> Void)
}

// sourcery: InjectRegister = "CoreDataManager"
// sourcery: InjectSingleton
class AppCoreDataManager: CoreDataManager {
    public static var shared: AppCoreDataManager = AppCoreDataManager()

    let persistentContainerQueue = OperationQueue() // make a queue for performing write operations to avoid conflicts with multiple writes at the same time from different contexts.
    static let nameOfModelFile = "Model" // The name of the .xcdatamodeld file you want to use.
    private let threadUtil: ThreadUtil = AppThreadUtil()

    // Note: Must call `loadStore()` to initialize. Do not forget to do that.
    init() {
        persistentContainerQueue.maxConcurrentOperationCount = 1

        if let storeURL = self.storeURL {
            let description = storeDescription(with: storeURL)
            persistentContainer.persistentStoreDescriptions = [description]
        }
    }

    /// The managed object context associated with the main queue (read-only).
    /// To perform tasks on a private background queue see
    /// `performBackgroundTask:` and `newPrivateContext`.
    var uiContext: NSManagedObjectContext {
        threadUtil.assertMain()

        return persistentContainer.viewContext
    }

    /// Create and return a new private queue `NSManagedObjectContext`. The
    /// new context is set to consume `NSManagedObjectContextSave` broadcasts
    /// automatically.
    ///
    /// Use this instead of the UI thread context when you want read-only background thread operations.
    ///
    /// - Returns: A new private managed object context
    public func newBackgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    func asyncWrite(_ block: @escaping (CDContext) -> Void) {
//        threadUtil.assertMain() // even though you will probably call from the UI thread, you can call it from any thread.

        persistentContainerQueue.addOperation {
            self.persistentContainer.performBackgroundTask { context in
                block(context)
                // We used to have `try! context.save()` here to automatically save. But, we shouldn't because saving can fail. So, require the caller of this function to handle when an error happens.
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

    /**
     Delete the old data store and recreate it. This is handy to delete all data for the user.
     */
    func reset(completionHandler: @escaping (Error?) -> Void) {
        // First, destroy the store to delete all data
        let psc = persistentContainer.persistentStoreCoordinator

        guard let storeUrl = storeURL else {
            completionHandler(nil)
            return
        }

        do {
            try psc.destroyPersistentStore(at: storeUrl, ofType: NSSQLiteStoreType, options: nil)
            // If you run `psc.addPersistentStore()` after destroy, it will throw an error saying that you cannot add a store twice.
        } catch {
            completionHandler(error)
            return
        }

        loadStore(completionHandler: completionHandler)
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
    func loadStore(completionHandler: @escaping (Error?) -> Void) {
        persistentContainer.loadPersistentStores { _, error in
            if error == nil {
                self.isStoreLoaded = true
                self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
                self.persistentContainer.viewContext.shouldDeleteInaccessibleFaults = true
            }

            DispatchQueue.main.async {
                completionHandler(error)
            }
        }
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(for: AppCoreDataManager.self)
        let mom = NSManagedObjectModel.mergedModel(from: [bundle])!

        return NSPersistentContainer(name: AppCoreDataManager.nameOfModelFile, managedObjectModel: mom)
    }()

    private func storeDescription(with url: URL) -> NSPersistentStoreDescription {
        let description = NSPersistentStoreDescription(url: url)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        description.shouldAddStoreAsynchronously = true
        description.isReadOnly = false
        description.type = NSSQLiteStoreType
        return description
    }
}
