//
//  DiTests.swift
//  iOSBlankyTests
//
//  Created by Levi Bostian on 7/19/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import XCTest
@testable import iOSBlanky

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

    // MARK - property injectors. This works because an exception will be thrown when trying to force cast
    func test_activityLogger() {
        XCTAssertNotNil(di.activityLogger)
    }

    func testDependencyGraph() {
        for dependency in Dependency.allCases {
            XCTAssertNotNil(di.inject(dependency), "Dependency: \(dependency) not able to resolve in dependency graph")
        }
    }

}
