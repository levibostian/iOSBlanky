import Foundation
import Wendy

extension PendingTasksRunnerResult {
    var requestError: HttpRequestError? {
        guard let firstFailure = self.firstFailedResult else {
            return nil
        }

        switch firstFailure {
        case .failure(let error):
            if let error = error as? HttpRequestError {
                return error
            }
            return HttpRequestError(fault: .user, message: error.localizedDescription, underlyingError: error)
        case .skipped(let reason):
            switch reason {
            case .unresolvedRecordedError(let unresolvedError):
                return HttpRequestError(fault: .user, message: String(format: Strings.cannotPerformRequestUntilErrorsFixed.localized, unresolvedError.errorMessage!), underlyingError: nil)
            default:
                return HttpRequestError(fault: .user, message: Strings.cannotPerformHttpRequestPendingTasksFailed.localized, underlyingError: nil)
            }
        default:
            // No need to take care of other cases as firstFailResult only gives us skipped and failed cases
            return nil
        }
    }
}
