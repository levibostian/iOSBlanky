import Foundation

class ConsoleLogger {
    class func d(_ message: String) {
        print("debug: \(message)\n")
    }

    class func e(_ error: Error) {
        print("----------ERROR-----------\n")
        print("description: \(error.localizedDescription)\n")
        print("--------------------------\n")
    }
}
