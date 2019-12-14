import Foundation
@testable import iOSBlanky
import XCTest

class NotificationUtilTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        TestUtil.tearDown()

        super.tearDown()
    }

    func test_parseDataNotification_givenEmptyUserInfo_expectNil() {
        let actual = NotificationUtil.parseDataNotification(from: [:])

        XCTAssertNil(actual)
    }

    func test_parseDataNotification_givenTopicDataNotification_expectNotificationWithTopic() {
        let givenNameOfTopic = "nameOfTopic"

        let givenNotifictionInfo = [
            "topicName": givenNameOfTopic
        ]

        let actual = NotificationUtil.parseDataNotification(from: givenNotifictionInfo)

        XCTAssertEqual(actual, DataNotification(topicName: givenNameOfTopic))
    }

    func test_getActionFrom_givenDataNotificationWithoutTopic_expectNilAction() {
        let given = DataNotification(topicName: nil)

        let actual = NotificationUtil.getActionFrom(dataNotification: given)

        XCTAssertNil(actual)
    }

    func test_getActionFrom_givenDataNotificationWithTopic_expectAction() {
        let given = DataNotification(topicName: FcmTopicKeys.filesToDownload.value)

        let actual = NotificationUtil.getActionFrom(dataNotification: given)

        XCTAssertEqual(actual, NotificationAction.updateDrive)
    }
}
