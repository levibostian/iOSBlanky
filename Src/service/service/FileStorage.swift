import Foundation

protocol FileStorage {
    func write(_ text: String, fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) throws
    /**
     returns nil if file does not exist.
     */
    func readString(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> String?

    func write(_ data: Data, fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) throws
    /**
     returns nil if file does not exist.
     */
    func readData(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> Data?

    func getFileUrl(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> URL

    func getTempFileUrl() -> URL

    func copy(from: URL, to: URL) throws

    func delete(_ url: URL) throws

    func doesFileExist(at: URL) -> Bool
}

class FileMangerFileStorage: FileStorage {
    func write(_ text: String, fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) throws {
        let fileUrl = getFileUrl(fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)

        try text.write(to: fileUrl, atomically: true, encoding: .utf8)
    }

    func readString(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> String? {
        let fileUrl = getFileUrl(fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)

        guard fileUrl.doesFileExist else {
            return nil
        }

        return try! String(contentsOf: fileUrl, encoding: .utf8)
    }

    func write(_ data: Data, fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) throws {
        let fileUrl = getFileUrl(fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)

        try data.write(to: fileUrl)
    }

    func readData(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> Data? {
        let fileUrl = getFileUrl(fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)

        guard fileUrl.doesFileExist else {
            return nil
        }

        return try! Data(contentsOf: fileUrl)
    }

    func getFileUrl(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> URL {
        var directory = FileManager.default.urls(for: location, in: .userDomainMask).first!

        if let appendDirectoryName = appendedDirectory {
            directory.appendPathComponent(appendDirectoryName, isDirectory: true)
        }

        if !directory.doesDirectoryExist {
            try! FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        }

        let fileUrl = directory.appendingPathComponent(fileName, isDirectory: false)

        return fileUrl
    }

    func getTempFileUrl() -> URL {
        getFileUrl(fileName: UUID().uuidString, inSearchPath: .cachesDirectory, appendedDirectory: nil)
    }

    func copy(from: URL, to: URL) throws {
        try FileManager.default.copyItem(at: from, to: to)
    }

    func delete(_ url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }

    func doesFileExist(at: URL) -> Bool {
        at.doesFileExist
    }
}
