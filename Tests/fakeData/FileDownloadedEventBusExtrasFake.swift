import Foundation

struct FileDownloadedEventBusExtrasFakes {
    var success: FileDownloadedEventBusExtras {
        FileDownloadedEventBusExtras(fileId: "1")
    }
}

extension FileDownloadedEventBusExtras {
    static var fake: FileDownloadedEventBusExtrasFakes {
        FileDownloadedEventBusExtrasFakes()
    }
}
