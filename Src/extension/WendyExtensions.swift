import Foundation
import Wendy

extension PendingTasksRunnerResult {
    var requestError: HttpRequestError? {
        guard let firstFailure = firstFailedResult else {
            return nil
        }

        switch firstFailure {
        case .failure(let error):
            if let error = error as? HttpRequestError {
                return error
            }
            return HttpRequestError.user(message: error.localizedDescription, underlyingError: error)
        case .skipped(let reason):
            switch reason {
            case .unresolvedRecordedError(let unresolvedError):
                return HttpRequestError.user(message: String(format: Strings.cannotPerformRequestUntilErrorsFixed.localized, unresolvedError.errorMessage!), underlyingError: nil)
            default:
                return HttpRequestError.user(message: Strings.cannotPerformHttpRequestPendingTasksFailed.localized, underlyingError: nil)
            }
        default:
            // No need to take care of other cases as firstFailResult only gives us skipped and failed cases
            return nil
        }
    }
}
