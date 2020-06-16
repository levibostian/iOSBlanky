import Foundation

protocol JsonAdapter {
    func fromJson<T: Decodable>(_ json: Data) -> T
    func fromJsonArray<T: Decodable>(_ json: Data) -> [T]
    func toJson<T: Encodable>(_ obj: T) -> Data
    func toJsonArray<T: Encodable>(_ obj: [T]) -> Data
}

// sourcery: InjectRegister = "JsonAdapter"
class SwiftJsonAdpter: JsonAdapter {
    fileprivate let decoder: JSONDecoder
    fileprivate let encoder = JSONEncoder()

    init() {
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        encoder.dateEncodingStrategy = .iso8601
    }

    func fromJson<T: Decodable>(_ json: Data) -> T {
        try! decoder.decode(T.self, from: json)
    }

    func fromJsonArray<T: Decodable>(_ json: Data) -> [T] {
        try! decoder.decode([T].self, from: json)
    }

    func toJson<T: Encodable>(_ obj: T) -> Data {
        try! encoder.encode(obj)
    }

    func toJsonArray<T: Encodable>(_ obj: [T]) -> Data {
        try! encoder.encode(obj)
    }
}
