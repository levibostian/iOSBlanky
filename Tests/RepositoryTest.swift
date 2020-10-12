@testable import App
import Foundation

class RepositoryTest: UnitTest {
    let threadUtil: ThreadUtil = ThreadUtilMock(enableAssertMain: false, enableAssertBackground: false)

    override func setUp() {
        DI.shared.override(.threadUtil, value: threadUtil, forType: ThreadUtil.self)

        super.setUp()
    }
}
