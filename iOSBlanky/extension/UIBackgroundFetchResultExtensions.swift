import Foundation
import UIKit

extension UIBackgroundFetchResult {
    var name: String {
        switch self {
        case .newData: return "newData"
        case .noData: return "noData"
        case .failed: return "failed"
        @unknown default:
            fatalError()
        }
    }

    static func get(from refreshResults: [RefreshResult]) -> UIBackgroundFetchResult {
        var numberSuccessfulFetches = 0
        var numberSkippedTasks = 0
        var numberFailedTasks = 0

        refreshResults.forEach { refreshResult in
            switch refreshResult {
            case .successful:
                numberSuccessfulFetches += 1
            case .skipped:
                numberSkippedTasks += 1
            case .failedError:
                numberFailedTasks += 1
            }
        }

        if refreshResults.isEmpty || (numberSuccessfulFetches == 0 && numberFailedTasks == 0) {
            return .noData
        } else if numberSuccessfulFetches >= numberFailedTasks {
            return .newData
        } else {
            return .failed
        }
    }

    static func singleResult(from collection: [UIBackgroundFetchResult]) -> UIBackgroundFetchResult {
        guard !collection.isEmpty else {
            return .noData
        }

        let numberNewData = collection.filter { $0 == .newData }.count
        let numberFailed = collection.filter { $0 == .failed }.count

        if numberNewData >= numberFailed {
            return .newData
        } else {
            return .failed
        }
    }
}
