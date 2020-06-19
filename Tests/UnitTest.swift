import Foundation
import UIKit
import XCTest

class UnitTest: XCTestCase {
    // Prefer to use real instance of key value storage because (1) mocking it is annoying and (2) tests react closely to real app.
    var keyValueStorage: KeyValueStorage!

    override func setUp() {
        DI.shared.override(.bundle, value: bundle, forType: Bundle.self)
        keyValueStorage = UserDefaultsKeyValueStorage(userDefaults: DI.shared.inject(.userDefaults))

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
