import Foundation

enum Strings: String, CaseIterable {
    case ok
    case githubUsername
    case howManyReposButtonText
    case noInternetConnectionErrorMessage
    case networkConnectionIssueErrorMessage
    case uncaughtNetworkErrorMessage
    case developerNetworkErrorMessage
    case error500ResponseCode
    case error401ResponseCode
    case userHasNoGithubRepos
    case cannotPerformRequestUntilErrorsFixed
    case cannotPerformHttpRequestPendingTasksFailed
    case developerErrorMessage // for when there is an error by the developer. error has been logged, but we need a human readable message shown to the user.
    case loggingIntoAppTitle
    case loggingIntoAppMessage
    case retry
    case cancel
    case accept
    case errorMessage_SavingDataToDevice
    case errorMessage_ReadingDataFromDevice
}

extension Strings {
    var localized: String {
        let key: String = rawValue

        let bundle = DI.shared.bundle

        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "") // swiftlint:disable:this use_strings_enum
    }
}
