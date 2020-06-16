import Firebase
import Foundation

protocol RemoteConfigProvider: AutoMockable {
    var someRemoteConfig: String? { get }

    func fetch(onComplete: @escaping (Result<Void, Error>) -> Void)
    func activate()
}

/**
 Firebase remote config have a fetch and activate type of workflow. There are many strategies to follow with when you call fetch and when you call activate: https://firebase.google.com/docs/remote-config/loading

 When you call activate, globally, all of the values will change which may cause issues with your UI and behavior. You want to call activate when the user is not heavily involved with the UI of the app. The strategy we are following in this app is to use a Teller Repository to periodically call fetch in the background when the app is not open. Then, when the app launches, we will call activate to make the changes that were fetched in the background, make them active.
 */
// sourcery: InjectRegister = "RemoteConfigProvider"
class FirebaseRemoteConfig: RemoteConfigProvider {
    fileprivate let remoteConfig = RemoteConfig.remoteConfig()
    fileprivate let logger: ActivityLogger

    init(logger: ActivityLogger, environment: Environment) {
        self.logger = logger

        if environment.isDevelopment {
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
            remoteConfig.configSettings = settings
        }
    }

    func activate() {
        remoteConfig.activateFetched()
    }

    func fetch(onComplete: @escaping (Result<Void, Error>) -> Void) {
        remoteConfig.fetch { status, error in
            if status == .success {
                onComplete(Result.success(Void()))
            } else if let error = error {
                onComplete(Result.failure(error))
            }
        }
    }
}

extension FirebaseRemoteConfig {
    var someRemoteConfig: String? {
        remoteConfig["some_remote_config_value"].stringValue
    }
}
