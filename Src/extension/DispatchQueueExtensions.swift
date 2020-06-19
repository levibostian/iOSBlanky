import Foundation

extension DispatchQueue {
    // This exists mostly for testing reasons to make async calls sync when testing UI elements
    func asyncOrSyncIfMain(_ run: @escaping () -> Void) {
        if Thread.isMainThread {
            run()
        } else {
            async(execute: run)
        }
    }

    static func newUniqueQueue(label: String, qos: DispatchQoS = .userInitiated) -> DispatchQueue {
        DispatchQueue(label: "\(label) \(UUID())", qos: qos)
    }
}
