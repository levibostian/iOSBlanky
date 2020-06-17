import Foundation

class Constants {
    static let apiVersion = "0.1.0"
    static let apiEndpoint: String = Env.apiEndpoint

    /**
     S3 static assets to make sure are all uploaded for viewing. List them all here as a convenient way to view all of the assets you need to upload to S3.
     */
    enum RemoteAssets {
        case favoritesImage

        var url: URL {
            switch self {
            case .favoritesImage: return try! "\(Env.assetsEndpoint)/generic/ic_favorites.jpg".asURL()
            }
        }
    }
}
