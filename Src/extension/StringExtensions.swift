import Foundation

extension String {
    // Thanks, https://gist.github.com/dmsl1805/ad9a14b127d0409cf9621dc13d237457
    func camelCaseToSnakeCase() -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let normalPattern = "([a-z0-9])([A-Z])"
        return processCamalCaseRegex(pattern: acronymPattern)?
            .processCamalCaseRegex(pattern: normalPattern)?.lowercased() ?? lowercased()
    }

    fileprivate func processCamalCaseRegex(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }

    // http://emailregex.com/
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: trimmingCharacters(in: .whitespacesAndNewlines))
    }

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
    func random(length: Int) -> String {
        String((0..<length).map { _ in abcLetters.randomElement()! }).capitalizingFirstLetter()
    }

    var data: Data? {
        data(using: .utf8)
    }

    // Turns: `https://www.foo.com?foo=Value and Value` into `https://www.foo.com?foo=Value%20and%20Value` for https links
    // Turns: `mailto:foo@foo.com?subject=Help with {{app_name}} app` into `mailto:foo@foo.com?subject=Help%20with%20app` for mailto links.
    // Now, the below is very manual. I tried using methods such as: https://useyourloaf.com/blog/how-to-percent-encode-a-url-string/ but found that it caused more issues that confused me and by doing it manually, it's no longer "magic".
    // This is required, especially for mailto links, to be able to be opened by Swift.
    // From: https://useyourloaf.com/blog/how-to-percent-encode-a-url-string/
    // Additional help: https://krypted.com/utilities/html-encoding-reference/
    func percentUrlEncode() -> String? {
        let httpUrl = components(separatedBy: "https://")
        let mailtoUrl = components(separatedBy: "mailto:")

        // From manual testing of taking a URL(string: "")! url and attempting to open it with `UIApplication.shared.open(url, options: [:], completionHandler: nil)`, this is what I have come up with:
        // %20 for spaces
        // %0D%0A for line breaks in mailto links. urls should not have line breaks.
        // ( and ) are ok
        // : are ok
        // . are ok
        func encode(_ value: String) -> String {
            value
                .replacingOccurrences(of: " ", with: "%20")
                .replacingOccurrences(of: "\n", with: "%0D%0A")
        }

        // I have found if you encode the beginning https:// or mailto: parts, then the system cannot open the URL as it's not valid. Leave the beginning alone.
        if httpUrl.count > 1 {
            return "https://" + encode(httpUrl[1])
        } else if mailtoUrl.count > 1 {
            let mailtoComponents = mailtoUrl[1].split(separator: "?")
            return "mailto:\(mailtoComponents[0])?\(encode(String(mailtoComponents[1])))"
        }

        return nil
    }
}
