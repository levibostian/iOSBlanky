import Foundation
import UIKit
import XCTest

class TestUtil {
    static let defaultWaitTimeout = 0.8

    class func setup(fileManagerDirectory: FileManager.SearchPathDirectory? = nil) {
        TestUtil.tearDown(fileManagerDirectory: fileManagerDirectory)
    }

    class func tearDown(fileManagerDirectory: FileManager.SearchPathDirectory? = nil) {
        DI.shared.resetOverrides()

        if let directory = fileManagerDirectory {
            FileManager.deleteAll(in: directory)
        }

        UserDefaults.standard.deleteAll()
    }
}
