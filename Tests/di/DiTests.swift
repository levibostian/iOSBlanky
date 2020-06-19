import Foundation
import XCTest

class DiTests: XCTestCase {
    func testDependencyGraphComplete() {
        for dependency in Dependency.allCases {
            XCTAssertNotNil(DI.shared.inject(dependency), "Dependency: \(dependency) not able to resolve in dependency graph")
        }
    }
}
