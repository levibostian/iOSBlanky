import Foundation

protocol Environment {
    var isDevelopment: Bool { get } // is locally developing the app.
    var appVersion: String { get }
}

// sourcery: InjectRegister = "Environment"
class AppEnvironment: Environment {
    private let bundle: Bundle

    init(bundle: Bundle) {
        self.bundle = bundle
    }

    var isDevelopment: Bool {
        Env.development == "true"
    }

    var appVersion: String {
        bundle.infoDictionary?["CFBundleShortVersionString"] as! String // swiftlint:disable:this force_cast
    }
}
