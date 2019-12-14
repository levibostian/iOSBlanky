import Foundation

extension FileManager {
    class func documentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }

    class func deleteAll(in searchDirectory: SearchPathDirectory) {
        let directoryUrl = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first!

        let fileUrls = try! FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])

        for fileUrl in fileUrls {
            try! FileManager.default.removeItem(at: fileUrl)
        }
    }
}
