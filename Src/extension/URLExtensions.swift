import Foundation
import Kingfisher
import UIKit

extension URL {
    // Send a URL string and it returns value of query param.
    // Example: http://example.com?test1=foo&test2=bar => param: test1 and get back 'foo'
    func getQueryParamValue(_ param: String) -> String? {
        guard let url = URLComponents(string: absoluteString) else { return nil }

        return url.queryItems?.first(where: { $0.name == param })?.value
    }

    static func random() -> URL {
        URL(string: "https://example.com/\("".random(length: 10)).html")!
    }

    var doesFileExist: Bool {
        FileManager.default.fileExists(atPath: path)
    }

    var doesDirectoryExist: Bool {
        doesFileExist
    }

    var canOpen: Bool {
        UIApplication.shared.canOpenURL(self)
    }

    func prefetch() {
        ImagePrefetcher(urls: [self]).start()
    }
}

extension Array where Element == URL {
    func prefetch() {
        ImagePrefetcher(urls: self).start()
    }
}
