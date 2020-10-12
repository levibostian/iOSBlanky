import Foundation

// sourcery: InjectRegister = "DataDestroyer"
class DataDestroyer {
    private let keyValueStorage: KeyValueStorage
    private let coreDataManager: CoreDataManager
    private let pendingTasks: PendingTasks

    init(keyValueStorage: KeyValueStorage, coreDataManager: CoreDataManager, pendingTasks: PendingTasks) {
        self.keyValueStorage = keyValueStorage
        self.coreDataManager = coreDataManager
        self.pendingTasks = pendingTasks
    }

    func destroyAll(onComplete: @escaping OnCompleteOptionalError) {
        DispatchQueue.global(qos: .background).async {
            self.keyValueStorage.deleteAll()
            self.pendingTasks.deleteAll()

            self.coreDataManager.reset { error in
                DispatchQueue.main.async {
                    onComplete(error)
                }
            }
        }
    }
}
