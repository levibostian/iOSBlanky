import Foundation
@testable import iOSBlanky
import XCTest

class FileStorageIntegrationTests: XCTestCase {
    var fileStorage: FileStorage!

    var directory: FileManager.SearchPathDirectory = .cachesDirectory

    override func setUp() {
        fileStorage = FileMangerFileStorage()
    }

    override func tearDown() {
        TestUtil.tearDown(fileManagerDirectory: directory)

        super.tearDown()
    }

    func test_deleteAll_expectDeletesAllFilesInDirectory() {
        let data = "foo"
        let filename = "filename"

        try! fileStorage.write(data, fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        FileManager.deleteAll(in: directory)

        let readAfterDelete = fileStorage.readString(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertNil(readAfterDelete)
    }

    func test_readAndWriteString() {
        let data = "string to read and write"
        let filename = "filename"

        try! fileStorage.write(data, fileName: filename, inSearchPath: directory, appendedDirectory: nil)
        let resultRead = fileStorage.readString(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertEqual(resultRead, data)
    }

    func test_readAndWriteData() {
        let data = try! Data(contentsOf: FileFakes.txt.url)
        let filename = "filename"

        try! fileStorage.write(data, fileName: filename, inSearchPath: directory, appendedDirectory: nil)
        let resultRead = fileStorage.readData(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertEqual(resultRead, data)
    }

    func test_getFileUrl_expectContainsFilename() {
        let filename = "nope"

        let result = fileStorage.getFileUrl(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertTrue(result.absoluteString.hasSuffix(filename))
    }

    func test_getFileUrl_fileDoesExist_expectNil() {
        let filename = "filename"
        try! fileStorage.write("foo", fileName: filename, inSearchPath: directory, appendedDirectory: nil)

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

        try! fileStorage.write(data, fileName: sourceFilename, inSearchPath: directory, appendedDirectory: nil)
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

        try! fileStorage.write(data, fileName: sourceFilename, inSearchPath: directory, appendedDirectory: nil)
        let sourceUrl = fileStorage.getFileUrl(fileName: sourceFilename, inSearchPath: directory, appendedDirectory: nil)

        let destinationUrl = fileStorage.getFileUrl(fileName: destinationFilename, inSearchPath: directory, appendedDirectory: nil)

        try! fileStorage.copy(from: sourceUrl, to: destinationUrl)

        let readResult = fileStorage.readString(fileName: destinationFilename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertEqual(readResult, data)
    }

    func test_delete_expectDeletesFile() {
        let data = "data"
        let filename = "filename"

        try! fileStorage.write(data, fileName: filename, inSearchPath: directory, appendedDirectory: nil)
        let fileUrl = fileStorage.getFileUrl(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertTrue(fileUrl.doesFileExist)

        try! fileStorage.delete(fileUrl)

        XCTAssertFalse(fileUrl.doesFileExist)
    }

    func test_doesFileExist_fileWrittenAtLocation_expectTrue() {
        let filename = "filename"
        try! fileStorage.write("foo", fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        let location = fileStorage.getFileUrl(fileName: filename, inSearchPath: directory, appendedDirectory: nil)

        XCTAssertTrue(fileStorage.doesFileExist(at: location))
    }

    func test_doesFileExist_noFileAtLocation_expectFalse() {
        let location = fileStorage.getFileUrl(fileName: "no-file-here", inSearchPath: directory, appendedDirectory: nil)

        XCTAssertFalse(fileStorage.doesFileExist(at: location))
    }
}
