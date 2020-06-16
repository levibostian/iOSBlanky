import Foundation

// sourcery: InjectRegister = "Bundle"
// sourcery: InjectCustom
extension DI {
    var bundle: Bundle {
        Bundle(for: AppDelegate.self)
    }
}
