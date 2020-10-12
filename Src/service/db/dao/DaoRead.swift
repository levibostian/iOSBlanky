import Foundation

/**
 Class that allows observing or just reading of database query. This allows our DAO classes to have less copy/pasted code as the DAO returns a DaoRead class result and the class using the DAO (like a Repository class) decides if it wants to observe or it wants to just get. Now, the DAO only needs to have 1 function for each read operation instead of 2 functions (one observable and one not observable). The DAO can also re-use these functions as well. If the DAO is perming reads inside of it, it can use functions from the DAO inside of the DAO itself.
 */
class DaoRead<Model: CDModel> {
    private let fetchRequest: CDFetchRequest<Model>
    private let dao: BaseDao

    init(fetchRequest: CDFetchRequest<Model>, dao: BaseDao) {
        self.fetchRequest = fetchRequest
        self.dao = dao
    }

    func observe() -> Observable<[Model]> {
        dao.read_observable(request: fetchRequest)
    }

    func get() -> [Model]? {
        dao.read(request: fetchRequest)
    }
}
