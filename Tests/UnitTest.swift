@testable import App
import Boquila
import CoreData
import Foundation
import UIKit
import XCTest

class UnitTest: XCTestCase {
    // Prefer to use real instance of key value storage because (1) mocking it is annoying and (2) tests react closely to real app.
    var keyValueStorage: KeyValueStorage!
    var coreDataManager: TestCoreDataManager! // = TestCoreDataManager()
    var remoteConfigAdapter: MockRemoteConfigAdapter!

    let schedulers: RxSchedulers = RxSchedulersMock()

    override func setUp() {
        // comment out because it's better to `@testable import App` and have the app code do all of the code execution which means the assets need to only exist in the app code not in the tests code.
//        DI.shared.override(.bundle, value: bundle, forType: Bundle.self)
        keyValueStorage = UserDefaultsKeyValueStorage(userDefaults: DI.shared.inject(.userDefaults))

        coreDataManager = TestCoreDataManager()
        DI.shared.override(.coreDataManager, value: coreDataManager, forType: CoreDataManager.self)

        remoteConfigAdapter = MockRemoteConfigAdapter()
        DI.shared.override(.remoteConfigAdapter, value: remoteConfigAdapter, forType: RemoteConfigAdapter.self)

        deleteAll()

        super.setUp()
    }

    override func tearDown() {
        deleteAll()

        DI.shared.resetOverrides()

        super.tearDown()
    }

    func deleteFiles(at searchPath: FileManager.SearchPathDirectory) {
        try! FileManager.default.deleteAll(in: searchPath)
    }

    func deleteAll() {
        deleteFiles(at: FileManager.defaultSearchPath)
        UserDefaults.standard.deleteAll()
        DI.shared.secureStorage.deleteAll()
    }
}
