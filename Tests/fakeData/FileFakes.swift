import Foundation

enum FileFakes {
    case txt

    var path: String {
        switch self {
        case .txt:
            return Bundle(for: TestUtil.self).path(forResource: "file", ofType: "txt")!
        }
    }

    var url: URL {
        URL(fileURLWithPath: path, isDirectory: false)
    }
}
