import Foundation
import RxSwift

enum FileAsset: CaseIterable {
    case foo

    var fileNameExtension: (String, String) {
        switch self {
        case .foo: return ("foo", "json")
        }
    }
}

protocol FileStorage: AutoMockable {
    func write(text: String, fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) throws
    /**
     returns nil if file does not exist.
     */
    func readString(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> String?

    /**
     When you have files bundled into your source code, use this.

     @param name File name of the file in your source code.
     @param ofType File extension. Example: "txt"
     */
    func readAsset(asset: FileAsset) -> Data?

    func write(data: Data, fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) throws
    /**
     returns nil if file does not exist.
     */
    func readData(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> Data?

    func getFileUrl(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> URL

    func getTempFileUrl() -> URL

    func copy(from: URL, to: URL) throws

    func delete(_ url: URL) throws

    func doesFileExist(at: URL) -> Bool

    func deleteAll(inSearchPath: FileManager.SearchPathDirectory) throws

    /// Note: This function is not perfect. It requires making FileManager a singleton, and if you write changes to a file immediately before observing, the observed changes will not be found. These changes requires a more direct implementation to the FileManager system entirely or a more common shared cache. Either way, this function is handy but doesn't always work.
    func observeFile(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> Observable<Optnal<Data>> // If does has no contents, observable will not trigger. Therefore, it's advised to readData() first before calling this.
}

/**
 We must use a singleton because of the file observables.
 */
// sourcery: InjectRegister = "FileStorage"
// sourcery: InjectSingleton
class FileMangerFileStorage: FileStorage {
    private var fileObservables: [String: BehaviorSubject<Optnal<Data>>] = [:]

    private let bundle: Bundle

    init(bundle: Bundle) {
        self.bundle = bundle
    }

    func write(text: String, fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) throws {
        let fileUrl = getFileUrl(fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)

        try text.write(to: fileUrl, atomically: true, encoding: .utf8)

        fileUpdated(newData: text.data!, fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)
    }

    func readString(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> String? {
        let fileUrl = getFileUrl(fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)

        guard fileUrl.doesFileExist else {
            return nil
        }

        let data = try! String(contentsOf: fileUrl, encoding: .utf8)

        if data.isEmpty {
            return nil
        } else {
            return data
        }
    }

    func readAsset(asset: FileAsset) -> Data? {
        let fileName = asset.fileNameExtension.0
        let ofType = asset.fileNameExtension.1

        guard let resourcePath = bundle.path(forResource: fileName, ofType: ofType) else {
            return nil
        }

        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: resourcePath) else {
            return nil
        }

        return fileManager.contents(atPath: resourcePath)
    }

    func write(data: Data, fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) throws {
        let fileUrl = getFileUrl(fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)

        try data.write(to: fileUrl)

        fileUpdated(newData: data, fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)
    }

    func readData(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> Data? {
        let fileUrl = getFileUrl(fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)

        guard fileUrl.doesFileExist else {
            return nil
        }

        let data = try! Data(contentsOf: fileUrl)

        if data.isEmpty {
            return nil
        } else {
            return data
        }
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

    func observeFile(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> Observable<Optnal<Data>> {
        let key = getFileObservablesKey(fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)
        if fileObservables[key] == nil {
            let fileContents = readData(fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)

            fileObservables[key] = BehaviorSubject(value: Optnal(value: fileContents))
        }

        return fileObservables[key]!.asObservable()
    }

    private func fileUpdated(newData: Data?, fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) {
        let key = getFileObservablesKey(fileName: fileName, inSearchPath: location, appendedDirectory: appendedDirectory)
        if let fileObserver = fileObservables[key] {
            fileObserver.on(.next(Optnal(value: newData)))
        }
    }

    private func getFileObservablesKey(fileName: String, inSearchPath location: FileManager.SearchPathDirectory, appendedDirectory: String?) -> String {
        "\(String(location.rawValue))_\(appendedDirectory ?? "")_\(fileName)"
    }

    func doesFileExist(at: URL) -> Bool {
        at.doesFileExist
    }

    func deleteAll(inSearchPath searchDirectory: FileManager.SearchPathDirectory) throws {
        try FileManager.default.deleteAll(in: searchDirectory)
    }
}
