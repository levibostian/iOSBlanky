import Foundation

enum FileDownloadedEventBusExtrasFake {
    case success

    var fake: FileDownloadedEventBusExtras {
        switch self {
        case .success:
            return FileDownloadedEventBusExtras(fileId: "1")
        }
    }
}
