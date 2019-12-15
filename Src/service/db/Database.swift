import Foundation

// Collection of DAOs so soemone needing to use 1+ DAOs have access to them all easily.
// sourcery: InjectRegister = "Database"
class Database {
    let repositoryDao: RepositoryDao

    init(coreDataManager: CoreDataManager) {
        self.repositoryDao = RepositoryDao(coreDataManager: coreDataManager)
    }
}
