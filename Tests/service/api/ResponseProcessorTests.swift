@testable import App
import Foundation
import Moya
import RxBlocking
import RxSwift
import XCTest

class ResponseProcessorTests: UnitTest {
    private var moyaMocker: MoyaProviderMocker<GitHubService>!

    private var responseProcessor: MoyaResponseProcessor!
    private var nilResponseExtraErrorHandling: (ProcessedResponse) -> HttpRequestError? = { response in
        nil
    }

    private var jsonAdapter: JsonAdapter!

    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
        moyaMocker = MoyaProviderMocker()
        jsonAdapter = DI.shared.jsonAdapter

        responseProcessor = MoyaResponseProcessor(jsonAdapter: jsonAdapter)
    }

    func test_processSuccess_given500_expectDeveloperError() {
        let given = Response(statusCode: 500, data: Data())

        let actual = responseProcessor.process(given, extraResponseHandling: nilResponseExtraErrorHandling)

        let requestError = actual.failure as? HttpRequestError
        XCTAssertNotNil(requestError)

        if case .developer = requestError!.fault {
        } else {
            XCTFail()
        }
    }

    func test_processSuccess_given409_expectConflictTypeError() {
        let givenConflictError = ConflictResponseError(message: "Error", errorId: ConflictResponseError.ErrorIdType.phoneNumberTaken.raw)
        let given = Response(statusCode: 409, data: try! jsonAdapter.toJson(givenConflictError))

        let actual = responseProcessor.process(given, extraResponseHandling: nilResponseExtraErrorHandling)

        let requestError = actual.failure as? HttpRequestError
        XCTAssertNotNil(requestError)

        if case .user = requestError!.fault {
        } else {
            XCTFail()
        }
        XCTAssertNotNil(requestError!.underlyingError)
        let actualConflictError = requestError!.underlyingError as? ConflictResponseError
        XCTAssertNotNil(actualConflictError)
    }

    func test_processSuccess_given429_expectRateLimitingTypeError() {
        let givenError = RateLimitingResponseError(error: RateLimitingResponseError.RateLimitingError(text: "wait and try again", nextValidRequestDate: Date()))
        let given = Response(statusCode: 429, data: try! jsonAdapter.toJson(givenError))

        let actual = responseProcessor.process(given, extraResponseHandling: nilResponseExtraErrorHandling)

        let requestError = actual.failure as? HttpRequestError
        XCTAssertNotNil(requestError)

        if case .user = requestError!.fault {
        } else {
            XCTFail()
        }
        XCTAssertNotNil(requestError!.underlyingError)
        let actualConflictError = requestError!.underlyingError as? RateLimitingResponseError
        XCTAssertNotNil(actualConflictError)
    }

    func test_processSuccess_given422_expectFieldsError() {
        let givenError = FieldsErrorResponse(message: "fields error message")
        let given = Response(statusCode: 422, data: try! jsonAdapter.toJson(givenError))

        let actual = responseProcessor.process(given, extraResponseHandling: nilResponseExtraErrorHandling)

        let requestError = actual.failure as? HttpRequestError
        XCTAssertNotNil(requestError)

        if case .developer = requestError!.fault {
        } else {
            XCTFail()
        }
        XCTAssertNotNil(requestError!.underlyingError)
        let actualConflictError = requestError!.underlyingError as? FieldsErrorResponse
        XCTAssertNotNil(actualConflictError)
    }

    func test_processSuccess_given400AndExtraErrorProcessing_expectReceiveExtraProcessingResult() {
        let givenError = HttpRequestError.user(message: "message", underlyingError: nil)
        let given = Response(statusCode: 410, data: "".data!)

        let actual = responseProcessor.process(given, extraResponseHandling: { response -> HttpRequestError? in
            givenError
        })

        let requestError = actual.failure as? HttpRequestError
        XCTAssertNotNil(requestError)

        if case .user = requestError!.fault {
        } else {
            XCTFail()
        }
        XCTAssertEqual(requestError!.message, givenError.message)
    }

    func test_processSuccess_given400_expectReceiveUnhandledDeveloperError() {
        let given = Response(statusCode: 410, data: "".data!)

        let actual = responseProcessor.process(given, extraResponseHandling: { response -> HttpRequestError? in
            nil
        })

        let requestError = actual.failure as? HttpRequestError
        XCTAssertNotNil(requestError)

        if case .developer = requestError!.fault {
        } else {
            XCTFail()
        }
        let unhandledError = requestError!.underlyingError as? UnhandledHttpResponseError
        XCTAssertNotNil(unhandledError)
    }

    func test_processSuccess_given200_expectReceiveNoError() {
        let given = Response(statusCode: 200, data: "body".data!)

        let actual = responseProcessor.process(given, extraResponseHandling: nilResponseExtraErrorHandling)

        let requestError = actual.failure as? HttpRequestError
        XCTAssertNil(requestError)

        let processedResponse = try! actual.get()
        XCTAssertEqual(processedResponse.data, given.data)
        XCTAssertEqual(processedResponse.statusCode, given.statusCode)
    }

    func test_processError_givenNoInternetError_expectNetworkError() {
        let given = MoyaError.underlying(URLError(.notConnectedToInternet), nil)

        let actual = responseProcessor.process(given)

        if case .network = actual.fault {
        } else {
            XCTFail()
        }
    }

    func test_processError_givenNetworkTimeout_expectNetworkError() {
        let given = MoyaError.underlying(URLError(.timedOut), nil)

        let actual = responseProcessor.process(given)

        if case .network = actual.fault {
        } else {
            XCTFail()
        }
    }

    func test_processError_givenOtherNetworkIssue_expectDeveloperError() {
        let given = MoyaError.underlying(URLError(.callIsActive), nil)

        let actual = responseProcessor.process(given)

        if case .developer = actual.fault {
        } else {
            XCTFail()
        }
    }

    func test_processError_givenErrorNotNetworkRelated_expectDeveloperError() {
        let given = MoyaError.underlying(URLError(.callIsActive), nil)

        let actual = responseProcessor.process(given)

        if case .developer = actual.fault {
        } else {
            XCTFail()
        }
    }
}
