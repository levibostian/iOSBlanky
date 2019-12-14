import Foundation

class Constants {
    static var buildFlavor: BuildFlavor {
        let buildFlavorString: String = Bundle.main.object(forInfoDictionaryKey: "Build flavor") as! String // swiftlint:disable:this force_cast

        return BuildFlavor.getFromString(buildFlavorString)
    }

    static let apiVersion = "0.1.0"
    static let apiEndpoint: String = Env.apiEndpoint
}
