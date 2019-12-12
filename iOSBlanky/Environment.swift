import Foundation

protocol Environment {
    var isDevelopment: Bool { get }
}

class AppEnvironment: Environment {
    var isDevelopment: Bool {
        return Env.development == "true"
    }
}
