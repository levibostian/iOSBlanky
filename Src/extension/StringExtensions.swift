import Foundation

extension String {
    // /Users/foo/FileName.png -> FileName.png
    func pathToFileName() -> FileName {
        String(split(separator: "/").last!)
    }

    // Credits: https://stackoverflow.com/a/26306372/1486374
    func capitalizingFirstLetter() -> String {
        prefix(1).uppercased() + lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }

    var abcLetters: String {
        "abcdefghijklmnopqrstuvwxyz"
    }

    // Credits: https://stackoverflow.com/a/26845710/1486374
    func randomName(length: Int) -> String {
        String((0..<length).map { _ in abcLetters.randomElement()! }).capitalizingFirstLetter()
    }

    var data: Data? {
        data(using: .utf8)
    }
}
