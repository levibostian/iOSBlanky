import Foundation
import Moya

struct ProcessedResponse {
    let statusCode: Int
    let data: Data
    let request: URLRequest?
    let response: HTTPURLResponse?
}

/**
 Responsibitiles
 1. Detect common errors that all APIs could encounter such as network connection issues and 500 status code errors.

 Do not perform any logging here or calling of event bus. Some APIs might not want that.
 */
// sourcery: InjectRegister = "MoyaResponseProcessor"
class MoyaResponseProcessor {
    private let jsonAdapter: JsonAdapter

    init(jsonAdapter: JsonAdapter) {
        self.jsonAdapter = jsonAdapter
    }

    func process(_ responseError: MoyaError) -> HttpRequestError {
            // I am only checking if the moyaError is of type MoyaError.underlying because the other type of MoyaErrors I want to propigate to the RxSwift onError case.
            // MoyaError.statusCode is where someone calls one of the Response.filter() functions to filter status code ranges. By default, I do not do any of that so, I need to let that error continue down the pipeline for others to catch.
        // Other MoyaErrors are mapping issues. These get thrown when someone calls one of the Response.map() functions and it fails. Again, I do not call any of these by default so I need to let those continue.
        switch responseError {
        case MoyaError.underlying(let error, _):
            if let urlError = error as? URLError {
                switch urlError.code {
                case URLError.Code.notConnectedToInternet:
                    return HttpRequestError(fault: .network, message: Strings.noInternetConnectionErrorMessage.localized, underlyingError: nil)
                // These are errors that can happen when you have a slow network connection. Nothing needs to be fixed by the developer.
                // Note: .cancelled is currently here because if a request is cancelled, it's probably because the user left the screen? So, they may not see the error message anyway. So, just return this generic "bad internet connection" error.
                case URLError.Code.timedOut, URLError.Code.networkConnectionLost, URLError.Code.cancelled:
                    return HttpRequestError(fault: .network, message: Strings.networkConnectionIssueErrorMessage.localized, underlyingError: nil)
                default:
                    // There was another network issue I am not aware of that happened.
                    return HttpRequestError(fault: .developer, message: Strings.uncaughtNetworkErrorMessage.localized, underlyingError: nil)
                }
            } else {
                // Another type of MoyaError. Because it's not network related, it's developer related.
                return HttpRequestError(fault: .developer, message: Strings.developerNetworkErrorMessage.localized, underlyingError: nil)
            }
        default:
            // Another type of MoyaError. Because it's not network related, it's developer related.
            return HttpRequestError(fault: .developer, message: Strings.developerNetworkErrorMessage.localized, underlyingError: nil)
        }
    }

    func process(_ response: Response, extraResponseHandling: (ProcessedResponse) -> HttpRequestError?) -> Result<ProcessedResponse, HttpRequestError> {
        let processedResponse = ProcessedResponse(statusCode: response.statusCode, data: response.data, request: response.request, response: response.response)

        switch response.statusCode {
        case 500...600:
            return Result.failure(HttpRequestError(fault: .developer, message: Strings.error500ResponseCode.localized, underlyingError: nil))
        case 409: // Conflict. User needs to edit something.
            let conflictError: ConflictResponseError = jsonAdapter.fromJson(response.data)

            return Result.failure(HttpRequestError(fault: .user, message: Strings.error500ResponseCode.localized, underlyingError: conflictError))
        case 400..<500:
            if let handledError = extraResponseHandling(processedResponse) {
                return Result.failure(handledError)
            } else {
                let unhandledError = UnhandledHttpResponseError(message: "Http call, \(response.request?.httpMethod ?? "(none)") \(response.request?.url?.absoluteString ?? "(none)"), unsuccessful (code: \(response.statusCode)) and the app code does not handle this response case.")

                return Result.failure(HttpRequestError(fault: .developer, message: Strings.uncaughtNetworkErrorMessage.localized, underlyingError: unhandledError))
            }
        default:
            return Result.success(processedResponse)
        }
    }
}
