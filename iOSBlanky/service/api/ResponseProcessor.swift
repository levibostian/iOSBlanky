import Foundation
import Moya

struct ProcessedResponse {
    let response: Response?
    let error: Error?
}

// sourcery: InjectRegister = "MoyaResponseProcessor"
class MoyaResponseProcessor {
    private let jsonAdapter: JsonAdapter
    private let logger: ActivityLogger
    private let eventBus: EventBus

    init(jsonAdapter: JsonAdapter, activityLogger: ActivityLogger, eventBus: EventBus) {
        self.jsonAdapter = jsonAdapter
        self.logger = activityLogger
        self.eventBus = eventBus
    }

    func process(_ responseError: Error) -> ProcessedResponse {
        if let moyaError = responseError as? MoyaError {
            // I am only checking if the moyaError is of type MoyaError.underlying because the other type of MoyaErrors I want to propigate to the RxSwift onError case.
            // MoyaError.statusCode is where someone calls one of the Response.filter() functions to filter status code ranges. By default, I do not do any of that so, I need to let that error continue down the pipeline for others to catch.
            // Other MoyaErrors are mapping issues. These get thrown when someone calls one of the Response.map() functions and it fails. Again, I do not call any of these by default so I need to let those continue.
            switch moyaError {
            case MoyaError.underlying(let error, let response):
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case URLError.Code.notConnectedToInternet:
                        return ProcessedResponse(response: response, error: NoInternetConnectionError(message: NSLocalizedString("no_internet_connection_error_message", comment: "The user does not have an Internet connection.")))
                    // These are errors that can happen when you have a slow network connection.
                    // Note: .cancelled is currently here because if a request is cancelled, it's probably because the user left the screen? So, they may not see the error message anyway. So, just return this generic "bad internet connection" error.
                    case URLError.Code.timedOut, URLError.Code.networkConnectionLost, URLError.Code.dnsLookupFailed, URLError.Code.secureConnectionFailed, URLError.Code.cancelled:
                        return ProcessedResponse(response: response, error: NetworkConnectionIssueError(message: NSLocalizedString("error_network_connection_issue", comment: "Error to show to the user. The user has a bad Internet connection.")))
                    default:
                        // There was another network issue I am not aware of that happened.
                        // Because many events can happen when a network connection is bad, I am catching them and evaluating what to do after I receive the incoming crash reports on certain errors. If an event happens often because of a slow network connection, I will put it in the list above to be handled in the app. If it's an issue with the API server, then I will fix it there.
                        logger.errorOccurred(urlError)
                        let errorMessage = NSLocalizedString("generic_network_error_message", comment: "Generic message to send to user indicating a network error happened we are not sure about.")
                        return ProcessedResponse(response: response, error: NetworkConnectionIssueError(message: errorMessage))
                    }
                } else {
                    // There is some other error that happened. Not sure what. Log it because it was probably a developer problem.
                    logger.errorOccurred(moyaError)
                    fatalError()
                }
            default:
                // There is some other error that happened. Not sure what. Log it because it was probably a developer problem.
                logger.errorOccurred(moyaError)
                fatalError()
            }
        } else {
            // There is some other error that happened. Not sure what. Log it because it was probably a developer problem.
            logger.errorOccurred(responseError)
            fatalError()
        }
    }

    func process(_ response: Response, extraResponseHandling: (_ statusCode: Int) -> Error?) -> ProcessedResponse {
        switch response.statusCode {
        case 500...600:
            return ProcessedResponse(response: response, error: ResponseServerError(message: NSLocalizedString("error_500_600_response_code", comment: "Error message to show to user")))
        case 409: // Conflict. User needs to edit something.
            let conflictError: ConflictResponseError = jsonAdapter.fromJson(response.data)
            return ProcessedResponse(response: response, error: conflictError)
        case 401:
            eventBus.post(.logout, extras: nil)

            return ProcessedResponse(response: response, error: UnauthorizedError(message: NSLocalizedString("error_401_response_code", comment: "Error to show to user")))
        case 400..<500:
            if let handledError = extraResponseHandling(response.statusCode) {
                return ProcessedResponse(response: response, error: handledError)
            } else {
                logger.errorOccurred(UnhandledHttpResponseError(message: "Http call, \(response.request?.httpMethod ?? "(none)") \(response.request?.url?.absoluteString ?? "(none)"), unsuccessful (code: \(response.statusCode)) and the app code does not handle this response case."))

                return ProcessedResponse(response: response, error: UnhandledHttpResponseError(message: NSLocalizedString("unhandled_http_response_code", comment: "There is an unknown error. The team has been notified to fix it. Try again later.")))
            }
        default:
            // successful.
            return ProcessedResponse(response: response, error: nil)
        }
    }
}
