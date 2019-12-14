import Foundation

enum Strings: String, CaseIterable {
    case ok
    case githubUsername
    case howManyReposButtonText
    case noInternetConnectionErrorMessage
    case networkConnectionIssueErrorMessage
    case uncaughtNetworkErrorMessage
    case error500ResponseCode
    case error401ResponseCode
}

extension Strings {
    var localized: String {
        let key: String = rawValue

        let bundle = DI.shared.bundle

        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "") // swiftlint:disable:this use_strings_enum
    }
}
