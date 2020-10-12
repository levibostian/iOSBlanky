import Foundation

/**
 Class that allows writing data in any way they wish. This allows our DAO classes to have less copy/pasted code as the DAO returns a DaoWrite class result and the class using the DAO (like a Repository class) decides how it wants to perform the write operation. Now, the DAO only needs to have 1 function for each read operation instead of 2 functions (one async, one sync). The DAO can also re-use these functions as well. If the DAO is perming writes inside of it, it can use `perform()` inside of another write block.
 */
class DaoWrite {
    private let block: (CDContext) throws -> Void
    private let dao: BaseDao

    init(block: @escaping (CDContext) throws -> Void, dao: BaseDao) {
        self.block = block
        self.dao = dao
    }

    /**
     Perform a synchronous write operation. Required to be on a background thread.
     */
    func sync() throws {
        try dao.write_sync(block)
    }

    /**
     Perform an async write operation. Usually done from a UI thread.
     */
    func async(onComplete: @escaping OnCompleteOptionalError) {
        dao.write_async(writeBlock: block, onComplete: onComplete)
    }

    /**
     Called from another DAO function. Write operation is performed from within another DAO block.  This allows DAO functions to be re-used.
     */
    func perform(context: CDContext) throws {
        try block(context)
    }
}
