@testable import App
import Foundation

struct URLFakes {
    var random: URL {
        URL(string: "https://foo.com/\("".random(length: 5))/link.html")!
    }

    var randomImage: URL {
        URL(string: "https://foo.com/\("".random(length: 5))/image.jpg")!
    }
}

extension URL {
    static var fake: URLFakes {
        URLFakes()
    }
}
