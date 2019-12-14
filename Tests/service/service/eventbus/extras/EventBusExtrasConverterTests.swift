import Foundation
@testable import iOSBlanky
import XCTest

class EventBusExtrasConverterTests: XCTestCase {
    func test_get_fileDownload_expectGetExtras() {
        let givenExtras = FileDownloadedEventBusExtrasFake.success.fake

        let actual: FileDownloadedEventBusExtras = givenExtras.toExtras().get(for: .fileDownloaded)

        XCTAssertEqual(givenExtras.fileId, actual.fileId)
    }
}
