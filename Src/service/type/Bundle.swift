import Foundation

// sourcery: InjectRegister = "Bundle"
// sourcery: InjectCustom
extension DI {
    var bundle: Bundle {
        return Bundle(for: AppDelegate.self)
    }
}
