import Foundation

// sourcery: InjectRegister = "Bundle"
// sourcery: InjectCustom
extension Bundle {}

extension DI {
    var bundle: Bundle {
        Bundle(for: AppDelegate.self)
    }
}
