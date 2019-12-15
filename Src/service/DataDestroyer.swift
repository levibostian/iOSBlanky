import Foundation

// sourcery: InjectRegister = "DataDestroyer"
class DataDestroyer {
    private let keyValueStorage: KeyValueStorage
    private let database: Database
    private let pendingTasks: PendingTasks

    init(keyValueStorage: KeyValueStorage, database: Database, pendingTasks: PendingTasks) {
        self.keyValueStorage = keyValueStorage
        self.database = database
        self.pendingTasks = pendingTasks
    }

    func destroyAll(onComplete: @escaping OnComplete) {
        keyValueStorage.deleteAll()
        pendingTasks.deleteAll()
        database.deleteAll(onComplete: {
            DispatchQueue.main.async {
                onComplete()
            }
        })
    }
}
