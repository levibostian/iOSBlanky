import Foundation
import UIKit

enum FontKey: String, CaseIterable {
    case bold = "Comfortaa-Bold"
    case regular = "Comfortaa"
    case thin = "Comfortaa-Thin"
}

extension UIFont {
    static func get(font: FontKey, size: CGFloat) -> UIFont {
        // Uncomment this if you are finding issues with using your custom font in your app. The name of the file *may not* be the same name that iOS puts into your Bundle. Use this code to print out all of the fonts in the app and you can then find the actual name iOS gave you.
        // Thanks, https://codewithchris.com/common-mistakes-with-adding-custom-fonts-to-your-ios-app/
        //        for family: String in UIFont.familyNames {
        //            print(family)
        //            for names: String in UIFont.fontNames(forFamilyName: family) {
        //                print("== \(names)")
        //            }
        //        }

        // Return system font if custom not found because of Unit testing.
        // We check custom fonts work in UI and QA testing.
        // Thanks, https://stackoverflow.com/a/37212033/1486374
        UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
