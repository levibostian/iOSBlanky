import Foundation
import Moya

class MoyaProviderMocker<Service: TargetType> {
    class Queue {
        private var queue: [QueueResponse] = []

        func pop() -> QueueResponse {
            return queue.remove(at: 0)
        }

        func append(_ item: QueueResponse) {
            queue.append(item)
        }
    }

    var moyaProvider: MoyaProvider<Service> {
        let sampleResponseClosure: () -> EndpointSampleResponse = {
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

        let endpointClosure: (Service) -> Endpoint = { (target: Service) -> Endpoint in
            Endpoint(url: URL(target: target).absoluteString,
                     sampleResponseClosure: sampleResponseClosure,
                     method: target.method,
                     task: target.task,
                     httpHeaderFields: target.headers)
        }

        return MoyaProvider(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    }

    private let queue: Queue = Queue()
    private let jsonAdapter: JsonAdapter = DI.shared.jsonAdapter

    func queueResponse<DATA: Encodable>(_ statusCode: Int, data: DATA) {
        queue.append(QueueResponse(type: .response, statusCode: statusCode, rawResponse: nil, data: jsonAdapter.toJson(data), error: nil))
    }

    func queueResponse<DATA: Encodable>(_ statusCode: Int, data: [DATA]) {
        queue.append(QueueResponse(type: .response, statusCode: statusCode, rawResponse: nil, data: jsonAdapter.toJsonArray(data), error: nil))
    }

    func queueResponse(_ statusCode: Int, data: Data) {
        queue.append(QueueResponse(type: .response, statusCode: statusCode, rawResponse: nil, data: jsonAdapter.toJson(data), error: nil))
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
