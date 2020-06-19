@testable import App
import Foundation
import RxSwift
import Teller
import XCTest

/**
 Tests cannot be written until we can mock DriveRepository.
 */
class RemoteConfigTests: UnitTest {
    var remoteConfig: FirebaseRemoteConfig!

    var loggerMock: ActivityLoggerMock!

    override func setUp() {
        super.setUp()

        loggerMock = ActivityLoggerMock()

        remoteConfig = FirebaseRemoteConfig(logger: loggerMock, environment: DI.shared.inject(.environment), jsonAdapter: DI.shared.inject(.jsonAdapter), stringReplaceUtil: DI.shared.inject(.stringReplaceUtil), keyValueStorage: DI.shared.inject(.keyValueStorage), fileStorage: DI.shared.inject(.fileStorage))
    }

    // MARK: - Test default values

    func test_allRemoteConfigKeysWithDefaultValuesWork() {
        // Test that getting the string value and deserializing of a remote config key with a default value works.
        for key in RemoteConfigKey.allCases {
            if key.defaultKey != nil {
                XCTAssertNotNil(key.getValue(provider: remoteConfig))
            } else {
                XCTAssertNil(key.getValue(provider: remoteConfig))
            }
        }
    }
}
