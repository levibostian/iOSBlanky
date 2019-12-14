import Foundation
@testable import iOSBlanky
import XCTest

class UIImagesTests: UnitTest {
    func test_allImagesDefined() {
        for image in Images.allCases {
            XCTAssertNotNil(image.image)
        }
    }
}
