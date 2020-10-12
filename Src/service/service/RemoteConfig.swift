import Boquila
import Firebase
import FirebaseRemoteConfig
import Foundation

// sourcery: InjectRegister = "RemoteConfigAdapter"
// sourcery: InjectCustom
extension RemoteConfigAdapter {}

extension DI {
    var remoteConfigAdapter: RemoteConfigAdapter {
        let environment: Environment = DI.shared.inject(.environment)

        return FirebaseRemoteConfigAdapter(firebaseRemoteConfig: RemoteConfig.remoteConfig(), development: environment.isDevelopment, plugins: RemoteConfigUtil.plugins)
    }
}

// sourcery: InjectRegister = "JsonRemoteConfigAdapterPlugin"
// sourcery: InjectCustom
// sourcery: InjectSingleton
extension JsonRemoteConfigAdapterPlugin {}

extension DI {
    var jsonRemoteConfigAdapterPlugin: JsonRemoteConfigAdapterPlugin {
        let jsonAdapter: JsonAdapter = DI.shared.inject(.jsonAdapter)

        let plugin = JsonRemoteConfigAdapterPlugin(jsonEncoder: jsonAdapter.encoder, jsonDecoder: jsonAdapter.decoder)

        // Note: Make sure to set `delegate` on plugin. That's why we are setting this plugin as a singleton.
        return plugin
    }
}

class RemoteConfigUtil {
    static var plugins: [RemoteConfigAdapterPlugin] {
        let environment: Environment = DI.shared.inject(.environment)
        let jsonAdapterPlugin: JsonRemoteConfigAdapterPlugin = DI.shared.inject(.jsonRemoteConfigAdapterPlugin)

        var plugins: [RemoteConfigAdapterPlugin] = [jsonAdapterPlugin]
        if environment.isDevelopment {
            plugins.append(PrintLoggingRemoteConfigAdapterPlugin())
        }

        return plugins
    }
}

extension MockRemoteConfigAdapter {
    convenience init() {
        self.init(plugins: RemoteConfigUtil.plugins)
    }
}
