import Foundation

enum NotificationAction {
    case updateDrive
}

struct DataNotification: Equatable {
    let topicName: String?
}

class NotificationUtil {
    // The one place that we identify the structure of push notifications coming in.
    // At this time, we are using FCM. This function knows how to parse them.
    static func parseDataNotification(from userInfo: [AnyHashable: Any]) -> DataNotification? {
        // at this time, a data notifiation requires a topic name to exist or it is not considered a data notification
        guard let topicName: String = userInfo["topicName"] as? String else {
            return nil
        }

        return DataNotification(topicName: topicName)
    }

    static func getActionFrom(dataNotification: DataNotification) -> NotificationAction? {
        guard let topicName = dataNotification.topicName else {
            return nil
        }

        switch topicName {
        case FcmTopicKeys.filesToDownload.value: return .updateDrive
        default: return nil
        }
    }
}
