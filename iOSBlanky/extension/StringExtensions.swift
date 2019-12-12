import Foundation

extension String {
    // /Users/foo/FileName.png -> FileName.png
    func pathToFileName() -> FileName {
        return String(split(separator: "/").last!)
    }
}
