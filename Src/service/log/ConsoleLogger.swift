import Foundation

class ConsoleLogger {
    private let environment: Environment

    init(environment: Environment) {
        self.environment = environment
    }

    func d(_ message: String) {
        if environment.isDevelopment {
            print("debug: \(message)\n")
        }
    }

    func e(_ error: Error) {
        if environment.isDevelopment {
            print("----------ERROR-----------\n")
            print("description: \(error.localizedDescription)\n")
            print("--------------------------\n")
        }
    }
}
