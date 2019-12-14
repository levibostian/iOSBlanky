import Foundation

protocol EventBusExtrasConverter {
    associatedtype Converter

    func toExtras() -> EventBusExtras
    static func fromExtras(_ extras: EventBusExtras) -> Converter
}

extension EventBusExtras {
    func get<T: EventBusExtrasConverter>(for event: EventBusEvent) -> T {
        switch event {
        case .fileDownloaded:
            return FileDownloadedEventBusExtras.fromExtras(self) as! T // swiftlint:disable:this force_cast
        default:
            fatalError("forgot a case")
        }
    }
}
