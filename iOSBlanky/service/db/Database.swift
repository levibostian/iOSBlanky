import Foundation

// Collection of DAOs so soemone needing to use 1+ DAOs have access to them all easily.
class Database {
    let repositoryDao: RepositoryDao

    init(repositoryDao: RepositoryDao) {
        self.repositoryDao = repositoryDao
    }
}
