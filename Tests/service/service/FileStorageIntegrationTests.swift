@testable import App
import Foundation
import XCTest

class FileStorageIntegrationTests: UnitTest {
    var fileStorage: FileStorage!

    var directory: FileManager.SearchPathDirectory = FileManager.defaultSearchPath

    override func setUp() {
        super.setUp()

        fileStorage = FileMangerFileStorage(bundle: DI.shared.inject(.bundle))
    }

    override func tearDown() {
        deleteFiles(at: directory)

        super.tearDown()
    }

    func test_readAndWriteString() {
        let data = "string to read and write"
        let filename = "filename"

        try! fileStorage.write(text: data, fileName: filename, inSearchPath: directory, appendedDirectory: nil)
        let resultRead = fileStorage.readString(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertEqual(resultRead, data)
    }

    func test_readAndWriteString_givenEmptyString_expectNilResult() {
        let data = ""
        let filename = "filename"

        try! fileStorage.write(text: data, fileName: filename, inSearchPath: directory, appendedDirectory: nil)
        let resultRead = fileStorage.readString(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertNil(resultRead)
    }

    func test_readAndWriteData() {
        let data = try! Data(contentsOf: FileFakes.txt.url)
        let filename = "filename"

        try! fileStorage.write(data: data, fileName: filename, inSearchPath: directory, appendedDirectory: nil)
        let resultRead = fileStorage.readData(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertEqual(resultRead, data)
    }

    func test_readAndWriteData_givenEmptyData_expectNilResult() {
        let data = "".data!
        let filename = "filename"

        try! fileStorage.write(data: data, fileName: filename, inSearchPath: directory, appendedDirectory: nil)
        let resultRead = fileStorage.readData(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertNil(resultRead)
    }

    func test_getFileUrl_expectContainsFilename() {
        let filename = "nope"

        let result = fileStorage.getFileUrl(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertTrue(result.absoluteString.hasSuffix(filename))
    }

    func test_getFileUrl_fileDoesExist_expectNil() {
        let filename = "filename"
        try! fileStorage.write(text: "foo", fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        let result = fileStorage.getFileUrl(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertNotNil(result)
        XCTAssertTrue(result.absoluteString.hasSuffix(filename))
    }

    func test_getTempUrl_expectDiffResultEachCall() {
        let firstResult = fileStorage.getTempFileUrl()
        let secondResult = fileStorage.getTempFileUrl()

        XCTAssertNotEqual(firstResult, secondResult)
    }

    func test_copy_useTempUrl_expectCopiesToDestination() {
        let sourceFilename = "source"
        let data = "foo"

        try! fileStorage.write(text: data, fileName: sourceFilename, inSearchPath: directory, appendedDirectory: nil)
        let sourceUrl = fileStorage.getFileUrl(fileName: sourceFilename, inSearchPath: directory, appendedDirectory: nil)

        let destinationUrl = fileStorage.getTempFileUrl()

        try! fileStorage.copy(from: sourceUrl, to: destinationUrl)

        let readResult = try! String(contentsOf: destinationUrl, encoding: .utf8)

        XCTAssertEqual(readResult, data)
    }

    func test_copy_expectCopiesToDestination() {
        let sourceFilename = "source"
        let destinationFilename = "destination"
        let data = "foo"

        try! fileStorage.write(text: data, fileName: sourceFilename, inSearchPath: directory, appendedDirectory: nil)
        let sourceUrl = fileStorage.getFileUrl(fileName: sourceFilename, inSearchPath: directory, appendedDirectory: nil)

        let destinationUrl = fileStorage.getFileUrl(fileName: destinationFilename, inSearchPath: directory, appendedDirectory: nil)

        try! fileStorage.copy(from: sourceUrl, to: destinationUrl)

        let readResult = fileStorage.readString(fileName: destinationFilename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertEqual(readResult, data)
    }

    func test_delete_expectDeletesFile() {
        let data = "data"
        let filename = "filename"

        try! fileStorage.write(text: data, fileName: filename, inSearchPath: directory, appendedDirectory: nil)
        let fileUrl = fileStorage.getFileUrl(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertTrue(fileUrl.doesFileExist)

        try! fileStorage.delete(fileUrl)

        XCTAssertFalse(fileUrl.doesFileExist)
    }

    func test_doesFileExist_fileWrittenAtLocation_expectTrue() {
        let filename = "filename"
        try! fileStorage.write(text: "foo", fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        let location = fileStorage.getFileUrl(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertTrue(fileStorage.doesFileExist(at: location))
    }

    func test_doesFileExist_noFileAtLocation_expectFalse() {
        let location = fileStorage.getFileUrl(fileName: "no-file-here", inSearchPath: directory, appendedDirectory: nil)

        XCTAssertFalse(fileStorage.doesFileExist(at: location))
    }

    func test_deleteAll_expectDeletesAll() {
        let filename1 = "filename1"
        try! fileStorage.write(text: "foo", fileName: filename1, inSearchPath: directory, appendedDirectory: nil)
        let fileUrl1 = fileStorage.getFileUrl(fileName: filename1, inSearchPath: directory, appendedDirectory: nil)

        let filename2 = "filename2"
        try! fileStorage.write(text: "bar", fileName: filename2, inSearchPath: directory, appendedDirectory: nil)
        let fileUrl2 = fileStorage.getFileUrl(fileName: filename2, inSearchPath: directory, appendedDirectory: nil)

        try! fileStorage.deleteAll(inSearchPath: directory)

        XCTAssertFalse(fileUrl1.doesFileExist)
        XCTAssertFalse(fileUrl2.doesFileExist)
    }

    func test_observeFile_givenFileDoesNotExist_assertObserveNoValue() {
        let actual = try! fileStorage.observeFile(fileName: "does-not-exist-file-here.txt", inSearchPath: directory, appendedDirectory: nil)
            .toBlocking()
            .first()!

        XCTAssertNil(actual.value)
    }

    func test_observeFile_givenFileExists_assertObserveFileContents() {
        let givenFileContents = "file-content".data!
        let givenFileName = "file-name.txt"

        let observable = fileStorage.observeFile(fileName: givenFileName, inSearchPath: directory, appendedDirectory: nil)
        try! fileStorage.write(data: givenFileContents, fileName: givenFileName, inSearchPath: directory, appendedDirectory: nil)

        let actual = try! observable
            .toBlocking()
            .first()!

        XCTAssertEqual(actual.value, givenFileContents)
    }

    func test_readAsset_givenAllFileAssets_expectEachToExistAndRead() {
        for fileAsset in FileAsset.allCases {
            let assetData = fileStorage.readAsset(asset: fileAsset)

            XCTAssertNotNil(assetData)
            XCTAssertFalse(assetData!.string!.isEmpty)
        }
    }
}
