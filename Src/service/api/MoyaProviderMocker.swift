import Foundation
import Moya

enum MoyaProviderMockerError: Error {
    case queueEmpty
}

extension MoyaProviderMockerError: LocalizedError {
    var errorDescription: String? {
        localizedDescription
    }

    var localizedDescription: String {
        switch self {
        case .queueEmpty: return "Queue empty!"
        }
    }
}

class MoyaProviderMocker<Service: TargetType> {
    class Queue {
        private var queue: [QueueResponse] = []

        func pop() -> QueueResponse {
            queue.remove(at: 0)
        }

        func peek() -> QueueResponse? {
            guard !queue.isEmpty else {
                return nil
            }
            return queue[0]
        }

        var count: Int {
            queue.count
        }

        func append(_ item: QueueResponse) {
            queue.append(item)
        }
    }

    var moyaProvider: MoyaProvider<Service> {
        let sampleResponseClosure: () -> EndpointSampleResponse = {
            guard self.queue.peek() != nil else {
                return .networkError(MoyaProviderMockerError.queueEmpty as NSError)
            }

            let nextQueueItem = self.queue.pop()

            let response: EndpointSampleResponse
            switch nextQueueItem.type {
            case .response:
                response = .networkResponse(nextQueueItem.statusCode!, nextQueueItem.data!)
            case .rawResponse:
                response = .response(nextQueueItem.rawResponse!, nextQueueItem.data!)
            case .networkError:
                response = .networkError(nextQueueItem.error! as NSError)
            }

            return response
        }

        let stubClosure: (Service) -> StubBehavior = { _ -> StubBehavior in
            var delayInSeconds: TimeInterval = 0
            if self.queue.peek() == nil {
                delayInSeconds = 10.0

                // infinite amount of time for local developing for breakpoints.
                if DI.shared.environment.isDevelopment {
                    delayInSeconds = 100000.0
                }
            }

            return .delayed(seconds: delayInSeconds)
        }

        let endpointClosure: (Service) -> Endpoint = { (target: Service) -> Endpoint in
            Endpoint(url: URL(target: target).absoluteString,
                     sampleResponseClosure: sampleResponseClosure,
                     method: target.method,
                     task: target.task,
                     httpHeaderFields: target.headers)
        }

        return MoyaProvider(endpointClosure: endpointClosure, stubClosure: stubClosure)
    }

    let queue: Queue = Queue()
    private let jsonAdapter: JsonAdapter = DI.shared.jsonAdapter

    func queueResponse(_ statusCode: Int, data: String) {
        let data = data.data(using: .utf8)!

        queue.append(QueueResponse(type: .response, statusCode: statusCode, rawResponse: nil, data: data, error: nil))
    }

    func queueResponse<DATA: Encodable>(_ statusCode: Int, data: DATA) {
        queue.append(QueueResponse(type: .response, statusCode: statusCode, rawResponse: nil, data: try! jsonAdapter.toJson(data), error: nil))
    }

    func queueResponse<DATA: Encodable>(_ statusCode: Int, data: [DATA]) {
        queue.append(QueueResponse(type: .response, statusCode: statusCode, rawResponse: nil, data: try! jsonAdapter.toJson(data), error: nil))
    }

    func queueResponse(_ statusCode: Int, data: Data) {
        queue.append(QueueResponse(type: .response, statusCode: statusCode, rawResponse: nil, data: try! jsonAdapter.toJson(data), error: nil))
    }

    func queueRawResponse(response: HTTPURLResponse, data: Data) {
        queue.append(QueueResponse(type: .rawResponse, statusCode: nil, rawResponse: response, data: data, error: nil))
    }

    func queueNetworkError(_ error: Error) {
        queue.append(QueueResponse(type: .networkError, statusCode: nil, rawResponse: nil, data: nil, error: error))
    }

    struct QueueResponse {
        let type: ResponseType
        let statusCode: Int?
        let rawResponse: HTTPURLResponse?
        let data: Data?
        let error: Error?
    }

    enum ResponseType {
        case response
        case rawResponse
        case networkError
    }
}
