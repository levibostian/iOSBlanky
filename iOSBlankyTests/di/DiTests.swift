import Foundation
@testable import iOSBlanky
import XCTest

class DiTests: XCTestCase {
    private var di: DiContainer!

    override func setUp() {
        super.setUp()

        di = DiContainer()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - property injectors. This works because an exception will be thrown when trying to force cast

    func test_activityLogger() {
        XCTAssertNotNil(Di.inject.activityLogger)
    }

    func test_reposViewModel() {
        XCTAssertNotNil(Di.inject.reposViewModel)
    }

    func test_remoteConfig() {
        XCTAssertNotNil(Di.inject.remoteConfig)
    }

    func testDependencyGraphComplete() {
        for dependency in Dependency.allCases {
            XCTAssertNotNil(di.inject(dependency), "Dependency: \(dependency) not able to resolve in dependency graph")
        }
    }
}
