import Foundation

extension FileManager {
    class func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }

    static var defaultSearchPath: SearchPathDirectory {
        .documentDirectory
    }

    func deleteAll(in searchPath: SearchPathDirectory) throws {
        let directoryUrl = urls(for: searchPath, in: .userDomainMask).first!

        guard directoryUrl.doesDirectoryExist else {
            return
        }

        let fileUrls = try contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])

        for fileUrl in fileUrls {
            try removeItem(at: fileUrl)
        }
    }
}
