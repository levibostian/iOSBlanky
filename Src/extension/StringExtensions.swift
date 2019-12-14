import Foundation

extension String {
    // /Users/foo/FileName.png -> FileName.png
    func pathToFileName() -> FileName {
        return String(split(separator: "/").last!)
    }

    // Credits: https://stackoverflow.com/a/26306372/1486374
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }

    var abcLetters: String {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    }

    // Credits: https://stackoverflow.com/a/26845710/1486374
    func randomName(length: Int) -> String {
        return String((0..<length).map { _ in abcLetters.randomElement()! }).capitalizingFirstLetter()
    }
}
