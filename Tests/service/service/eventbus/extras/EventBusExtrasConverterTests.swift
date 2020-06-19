@testable import App
import Foundation
import XCTest

class EventBusExtrasConverterTests: XCTestCase {
    func test_get_fileDownload_expectGetExtras() {
        let givenExtras = FileDownloadedEventBusExtras.fake.success

        let actual: FileDownloadedEventBusExtras = givenExtras.toExtras().get(for: .fileDownloaded)

        XCTAssertEqual(givenExtras.fileId, actual.fileId)
    }
}
