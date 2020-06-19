@testable import App
import Foundation

/**
 For testing purposes, meant to create dynamic links similar to the code that the API uses.
 */
class DynamicLinkFake {
    /**
     Goal: Create a URL similar to this pattern: `https://preview.page.link/?link=https%3A%2F%2Fapp.foo.com%2F%3Ftoken%3D123` that the API creates.

     @param params Pass in string similar to: `passwordless_token=123&other_param=566`
     */
    static func getFromQueryParams(_ params: String) -> String {
        "https://preview.page.link/?link=\(encodeURIComponent("https://app.foo.com/?\(params)"))"
    }

    /**
     Swift equivalent of javascript's `encodeURIComponent()` which is used by the API to create dynamic links.

     Thanks, https://gist.github.com/Tobi3112/02c58e8fe7d4c9cede3c
     */
    static func encodeURIComponent(_ value: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-_.!~*'()")
        return value.addingPercentEncoding(withAllowedCharacters: characterSet)!
    }
}
