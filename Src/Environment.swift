import Foundation

protocol Environment {
    var isDevelopment: Bool { get }
}

// sourcery: InjectRegister = "Environment"
class AppEnvironment: Environment {
    var isDevelopment: Bool {
        Env.development == "true"
    }
}
