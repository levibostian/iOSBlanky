import CoreData
import Foundation

/**
 We use `NSError` because some services such as Firebase Crashlytics work better with NSError. Because NSError is an instance of Error, devs who don't need NSError can use this as a regular Error instance.
 */
class DaoErrors {
    static func performWriteBlockError(error: Error) -> NSError {
        NSError(domain: DaoError.performWriteBlockError(error: error).localizedDescription, code: 0, userInfo: nil)
    }

    static func performReadBlockError(error: Error) -> NSError {
        NSError(domain: DaoError.performReadBlockError(error: error).localizedDescription, code: 0, userInfo: nil)
    }

    enum DaoError: LocalizedError {
        case performWriteBlockError(error: Error)
        case performReadBlockError(error: Error)

        public var errorDescription: String? {
            localizedDescription
        }

        public var localizedDescription: String {
            switch self {
            case .performWriteBlockError: return Strings.errorMessage_SavingDataToDevice.localized
            case .performReadBlockError: return Strings.errorMessage_ReadingDataFromDevice.localized
            }
        }
    }
}

class BaseDao {
    let coreDataManager: CoreDataManager
    private let modelName: String
    private let logger: ActivityLogger
    private let threadUtil: ThreadUtil

    init(coreDataManager: CoreDataManager, modelName: String, logger: ActivityLogger, threadUtil: ThreadUtil) {
        self.coreDataManager = coreDataManager
        self.modelName = modelName
        self.logger = logger
        self.threadUtil = threadUtil
    }

    func deleteAll(onComplete: @escaping OnComplete) {
        coreDataManager.asyncWrite { context in
            let fetchAll = NSFetchRequest<NSFetchRequestResult>(entityName: self.modelName)
            let request = NSBatchDeleteRequest(fetchRequest: fetchAll)
            try! context.execute(request)
            try! context.save()

            onComplete()
        }
    }

    func getDaoWrite(_ block: @escaping (CDContext) throws -> Void) -> DaoWrite {
        DaoWrite(block: block, dao: self)
    }

    func getDaoRead<MODEL: CDModel>(request: NSFetchRequest<MODEL>) -> DaoRead<MODEL> {
        DaoRead(fetchRequest: request, dao: self)
    }

    /**
     Perform read that is Observable.
     */
    func read_observable<MODEL: NSManagedObject>(request: NSFetchRequest<MODEL>) -> Observable<[MODEL]> {
        coreDataManager.uiContext.rx.entities(fetchRequest: request)
    }

    /**
     Use in DAO subclasses for performing read operations. This has default error handling built-in.
     */
    func read<MODEL: NSManagedObject>(request: NSFetchRequest<MODEL>) -> [MODEL]? {
        let context = coreDataManager.uiContext

        do {
            return try context.fetch(request)
        } catch {
            logger.errorOccurred(error)

            return nil
        }
    }

    /**
      Use in DAO subclasses for performing write operations. This has default error handling built-in.
     */
    func write_async(writeBlock: @escaping (NSManagedObjectContext) throws -> Void, onComplete: @escaping OnCompleteOptionalError) {
        coreDataManager.asyncWrite { context in
            do {
                try writeBlock(context)

                onComplete(nil)
            } catch {
                self.logger.errorOccurred(error)

                onComplete(DaoErrors.DaoError.performWriteBlockError(error: error))
            }
        }
    }

    func write_sync(_ writeBlock: (CDContext) throws -> Void) throws {
        threadUtil.assertBackground() // this is a sync operation and should only be called on background thread.

        let context = coreDataManager.newBackgroundContext()

        do {
            try writeBlock(context)
        } catch {
            logger.errorOccurred(error)

            throw DaoErrors.DaoError.performWriteBlockError(error: error)
        }
    }
}
