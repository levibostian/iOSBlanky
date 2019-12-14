import Firebase
import Foundation

protocol RemoteConfigProvider {
    var someRemoteConfigValue: String { get }
    func fetch()
}

// sourcery: InjectRegister = "RemoteConfigProvider"
class FirebaseRemoteConfig: RemoteConfigProvider {
    fileprivate let remoteConfig = RemoteConfig.remoteConfig()
    fileprivate let logger: ActivityLogger

    init(logger: ActivityLogger) {
        self.logger = logger
        remoteConfig.setDefaults(fromPlist: "FirebaseRemoteConfigDefaults")
    }

    var someRemoteConfigValue: String {
        return remoteConfig["some_remote_config_value"].stringValue!
    }

    // You usually want to call this during the launch of your application.
    func fetch() {
        remoteConfig.fetch { status, error in
            if status == .success {
                self.remoteConfig.activate()
            } else if let error = error {
                self.logger.errorOccurred(error)
            }
        }
    }
}
