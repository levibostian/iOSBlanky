import Foundation

// Collection of DAOs so soemone needing to use 1+ DAOs have access to them all easily.
// sourcery: InjectRegister = "Database"
class Database {
    let repositoryDao: RepositoryDao
    let daos: [Dao]

    init(coreDataManager: CoreDataManager) {
        self.repositoryDao = RepositoryDao(coreDataManager: coreDataManager)

        self.daos = [
            repositoryDao
        ]
    }

    func deleteAll(onComplete: @escaping OnComplete) {
        func deleteAllHelper(_ daosToDeleteAllFrom: [Dao]) {
            guard !daosToDeleteAllFrom.isEmpty else {
                onComplete()
                return
            }

            daosToDeleteAllFrom[0].deleteAll {
                deleteAllHelper(Array(daosToDeleteAllFrom.dropFirst()))
            }
        }

        deleteAllHelper(daos)
    }
}
