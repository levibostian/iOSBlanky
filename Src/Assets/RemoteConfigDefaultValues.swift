import Foundation

class DefaultValues {
    static func get(_ key: DefaultValueKey, fileStorage: FileStorage) -> String {
        switch key {
        case .foo:
            return fileStorage.readAsset(asset: .foo)!.string!
        }
    }
}
