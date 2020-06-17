import Foundation

class ConsoleLogger {
    func d(_ message: String) {
        print("debug: \(message)\n")
    }

    func e(_ error: Error) {
        print("----------ERROR-----------\n")
        print("description: \(error.localizedDescription)\n")
        print("--------------------------\n")
    }
}
