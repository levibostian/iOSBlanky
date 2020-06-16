import Foundation

extension URL {
    // Send a URL string and it returns value of query param.
    // Example: http://example.com?test1=foo&test2=bar => param: test1 and get back 'foo'
    func getQueryParamValue(_ param: String) -> String? {
        guard let url = URLComponents(string: absoluteString) else { return nil }

        return url.queryItems?.first(where: { $0.name == param })?.value
    }

    var doesFileExist: Bool {
        FileManager.default.fileExists(atPath: path)
    }

    var doesDirectoryExist: Bool {
        doesFileExist
    }
}
