import Foundation

enum FcmTopicKeys {
    case filesToDownload
}

extension FcmTopicKeys {
    var value: String {
        switch self {
        case .filesToDownload: return "files_to_download"
        }
    }
}
