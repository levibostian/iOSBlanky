@testable import App
import Foundation
import XCTest

class UIImagesTests: UnitTest {
    func test_allImagesDefined() {
        for image in Images.allCases {
            XCTAssertNotNil(image.image)
        }
    }
}
