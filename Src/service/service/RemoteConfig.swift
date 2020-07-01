import Boquila
import Firebase
import Foundation

// sourcery: InjectRegister = "RemoteConfigAdapter"
// sourcery: InjectCustom
extension DI {
    var remoteConfigAdapter: RemoteConfigAdapter {
        let environment: Environment = DI.shared.inject(.environment)

        return FirebaseRemoteConfigAdapter(firebaseRemoteConfig: RemoteConfig.remoteConfig(), development: environment.isDevelopment, plugins: RemoteConfigUtil.plugins)
    }
}

class RemoteConfigUtil {
    static var plugins: [RemoteConfigAdapterPlugin] {
        let environment: Environment = DI.shared.inject(.environment)
        let jsonAdapter: JsonAdapter = DI.shared.inject(.jsonAdapter)

        var plugins: [RemoteConfigAdapterPlugin] = [JsonRemoteConfigAdapterPlugin(jsonEncoder: jsonAdapter.encoder, jsonDecoder: jsonAdapter.decoder)]
        if environment.isDevelopment {
            plugins.append(PrintLoggingRemoteConfigAdapterPlugin())
        }

        return plugins
    }
}
