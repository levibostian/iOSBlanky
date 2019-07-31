import Foundation

protocol FileStorage {
    func write(_ text: String, fileName: String, location: FileManager.SearchPathDirectory) throws
    /**
     returns nil if file does not exist.
     */
    func readString(fileName: String, location: FileManager.SearchPathDirectory) throws -> String?

    func write(_ data: Data, fileName: String, location: FileManager.SearchPathDirectory) throws
    /**
     returns nil if file does not exist.
     */
    func readData(fileName: String, location: FileManager.SearchPathDirectory) throws -> Data?
}

enum FileManagerError: Error {
    case directoryDoesNotExist
}

class FileMangerFileStorage: FileStorage {
    func write(_ text: String, fileName: String, location: FileManager.SearchPathDirectory = .documentDirectory) throws {
        let fileUrl = try getFileUrl(fileName: fileName, inDirectory: location)

        try text.write(to: fileUrl, atomically: true, encoding: .utf8)
    }

    func readString(fileName: String, location: FileManager.SearchPathDirectory) throws -> String? {
        let fileUrl = try getFileUrl(fileName: fileName, inDirectory: location)

        guard fileUrl.doesFileExist else {
            return nil
        }

        return try String(contentsOf: fileUrl, encoding: .utf8)
    }

    func write(_ data: Data, fileName: String, location: FileManager.SearchPathDirectory) throws {
        let fileUrl = try getFileUrl(fileName: fileName, inDirectory: location)

        try data.write(to: fileUrl)
    }

    func readData(fileName: String, location: FileManager.SearchPathDirectory) throws -> Data? {
        let fileUrl = try getFileUrl(fileName: fileName, inDirectory: location)

        guard fileUrl.doesFileExist else {
            return nil
        }

        return try Data(contentsOf: fileUrl)
    }

    private func getFileUrl(fileName: String, inDirectory location: FileManager.SearchPathDirectory) throws -> URL {
        guard let directory = FileManager.default.urls(for: location, in: .userDomainMask).first else {
            throw FileManagerError.directoryDoesNotExist
        }

        let fileUrl = directory.appendingPathComponent(fileName)

        return fileUrl
    }
}
