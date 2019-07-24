import Foundation

protocol JsonAdapter {
    func fromJson<T: Decodable>(_ json: Data) -> T
    func fromJsonArray<T: Decodable>(_ json: Data) -> [T]
    func toJson<T: Encodable>(_ obj: T) -> Data
}

class SwiftJsonAdpter: JsonAdapter {
    fileprivate let decoder: JSONDecoder
    fileprivate let encoder = JSONEncoder()

    init() {
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func fromJson<T: Decodable>(_ json: Data) -> T {
        return try! decoder.decode(T.self, from: json)
    }

    func fromJsonArray<T: Decodable>(_ json: Data) -> [T] {
        return try! decoder.decode([T].self, from: json)
    }

    func toJson<T: Encodable>(_ obj: T) -> Data {
        return try! encoder.encode(obj)
    }
}
