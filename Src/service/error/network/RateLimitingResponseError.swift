import Foundation

/**
 HTTP response code was 429

 Example response:
  ```
 {
 "error": {
 "text": "Too many requests in this time frame.",
 "nextValidRequestDate": "2019-03-18T13:26:25.249Z"
 }
 }
  ```
 */
struct RateLimitingResponseError: Codable {
    let error: RateLimitingError

    struct RateLimitingError: Codable {
        let text: String
        let nextValidRequestDate: Date
    }
}

extension RateLimitingResponseError: LocalizedError {
    var errorDescription: String? {
        localizedDescription
    }

    var localizedDescription: String {
        error.text
    }
}
