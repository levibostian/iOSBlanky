import Firebase
import Foundation

protocol RemoteConfigProvider: AutoMockable {
    var reposCta: CTA? { get }

    func fetch(onComplete: ((Result<Void, Error>) -> Void)?)
    func activate()
}

/**
 All of the keys used to retrieve values from remote config.
 */
enum RemoteConfigKey: String, Codable, CaseIterable, Comparable {
    case reposCta = "repos_cta"

    var hasDefeaultValue: Bool {
        defaultKey != nil
    }

    /// When a RemoteConfigKey has a default value, this is where you specify the key.
    var defaultKey: DefaultValueKey? {
        switch self {
        // If you have
//        case .bar: return .bar
        default:
            return nil
        }
    }

    /**
     Exists to test default values work for each remote config value.

     NOTE: This function is not tested. I could not determine a way to test it effectively so, make sure that this works.
     */
    func getValue(provider: RemoteConfigProvider) -> Any? {
        switch self {
        case .reposCta: return provider.reposCta
        }
    }

    static func < (lhs: RemoteConfigKey, rhs: RemoteConfigKey) -> Bool {
        let lhsIndex: Int = allCases.firstIndex(of: lhs)!
        let rhsIndex: Int = allCases.firstIndex(of: rhs)!

        return lhsIndex < rhsIndex
    }
}

/**
 If a default is set for a remote config value, the key exists here to retrieve the value.

 This enum exists for compile-time safety. If you add/remove a case in this enum, then the `DefaultValues` class where we get the default values from will be broken. If the compiler compiles everything, we can feel assured that default strings will exist for the enum.
 */
enum DefaultValueKey {
    case foo
}

enum FirebaseRemoteConfigError: Error {
    case fetchError
}

extension FirebaseRemoteConfigError: LocalizedError {
    var errorDescription: String? {
        localizedDescription
    }

    var localizedDescription: String {
        switch self {
        case .fetchError: return Strings.developerErrorMessage.localized
        }
    }
}

/**
 When using Firebase remote config, we use a "activate then fetch" type of workflow. To use remote config, you must fetch values and then call activate for them to go into effect. You don't want to activate when the app is being used by the user as it might instantly change the UI for the user and change things up for them while they are using the app. To prevent this, in the AppDelegate, we will call activate in order to activate the values that were fetched the last time the app was opened. Then, we call fetch immediately after to kick off a new refresh that will be used the next time the app is opened. Learn more: https://firebase.google.com/docs/remote-config/loading

 Now, when using remote config, there are many scenarios that can be encountered:
 1. You try to get a remote config value that has not yet been fetched and activated on the device. Just because you push an update in the firebase console does not mean devices have fetched that data yet. When the app first loads, we might fetch remote config but after an app is installed, we can no longer guarantee it's up-to-date.
 2. You retrieved a value from remote config successfully, but there is a developer bug where the value does not get deserialized successfully (example: deserializing a string from remote config into a VO object)
 3. Developer bug where either (1) you forgot to put a key/value into remote config console or (2) there is a typo in the key used in the app and in the console so you cannot get the value from remote config.

 To work with all of the scenarios above, this is the plan for how to work with remote config:
 1. Everything should be backwards compatible. This prevents issue #1 above. Example: If a JSON object is made in remote config's console as the value type, in the future when you want to make changes to that remote config value, you need to make sure to keep that JSON backwards compatible so the keys of the JSON need to stay and you can only edit the values of the keys or add keys.
 2. Assume that every value in remote config is optional. Make the app be able to work if there is ever a problem with getting a value from remote config. If you truly do need a value from remote config in order for the app to work, you need to set a default value in the app's code. We use unit tests to make sure that default values successfully work in the code so we can rely on them to deserialize the value from the key successfully. Make sure to run unit tests before you deploy your app! Unit tests are used to make sure that the defaults work for each environment.
 3. Detect when there are developer bugs and notify developer to fix them. Currently, we do this through code in the app that detects when developer issues exist and then create a Crashlytics notification to notify on an issue.
 */
// sourcery: InjectRegister = "RemoteConfigProvider"
// sourcery: InjectSingleton
class FirebaseRemoteConfig: RemoteConfigProvider {
    fileprivate let remoteConfig = RemoteConfig.remoteConfig()
    fileprivate let logger: ActivityLogger
    fileprivate let jsonAdapter: JsonAdapter
    fileprivate let stringReplaceUtil: StringReplaceUtil
    fileprivate let keyValueStorage: KeyValueStorage
    fileprivate let fileStorage: FileStorage

    init(logger: ActivityLogger, environment: Environment, jsonAdapter: JsonAdapter, stringReplaceUtil: StringReplaceUtil, keyValueStorage: KeyValueStorage, fileStorage: FileStorage) {
        self.logger = logger
        self.jsonAdapter = jsonAdapter
        self.stringReplaceUtil = stringReplaceUtil
        self.keyValueStorage = keyValueStorage
        self.fileStorage = fileStorage

        if environment.isDevelopment {
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
            remoteConfig.configSettings = settings
        }
    }

    func activate() {
        logger.breadcrumb("activate", extras: nil)

        remoteConfig.activateFetched()
    }

    func fetch(onComplete: ((Result<Void, Error>) -> Void)?) {
        logger.breadcrumb("fetch", extras: [
            "firstTime": remoteConfig.lastFetchTime == nil
        ])

        remoteConfig.fetch { status, error in
            if status == .success {
                self.logger.appEventOccurred(.remoteConfigFetchSuccess, extras: nil)
                self.logger.breadcrumb("remote config keys", extras: [
                    "all_keys": self.remoteConfig.allKeys(from: .remote)
                ])

                // Here, we are trying to find developer errors. We want to try and deserialize all of the values from remote config. If there is a deserialization error, log it as it's a developer error and the remote config value in the console needs to be updated.
                for key in RemoteConfigKey.allCases {
                    // For each remote config key, we need to test:
                    // 1. If remote config string fetched can be deserialized to an object correctly.
                    // Here, when we try to getValue(), if there is a deserialization error, it will be logged for us in that function.
                    let value = key.getValue(provider: self)

                    if value == nil {
                        // Don't log this. We may have left out the remote config value on purpose to make it optional and not show up in the app.
                    }
                }

                onComplete?(Result.success(Void()))
            } else if let error = error {
                self.logger.appEventOccurred(.remoteConfigFetchFail, extras: nil)
                self.logger.errorOccurred(error)

                onComplete?(Result.failure(FirebaseRemoteConfigError.fetchError))
            }
        }
    }

    func getStringFromRemoteConfig(key: RemoteConfigKey) -> String? {
        guard let stringValue = remoteConfig[key.rawValue].stringValue else {
            return nil
        }

        // firebase returns empty values when a remote config value does not exist.
        if stringValue.isEmpty {
            return nil
        }

        return stringValue
    }

    func getStringFromDefaults(key: DefaultValueKey) -> String {
        DefaultValues.get(key, fileStorage: fileStorage)
    }

    func string(for key: RemoteConfigKey) -> String? {
        var string = getStringFromRemoteConfig(key: key)

        if string == nil {
            if let defaultValueKey = key.defaultKey {
                string = getStringFromDefaults(key: defaultValueKey)
            } else {
                return nil
            }
        }

        string = stringReplaceUtil.replace(string!)

        return string
    }

    private func getObjOrNil<T: Codable>(key: RemoteConfigKey) -> T? {
        guard let configData = string(for: key)?.data else {
            return nil
        }

        do {
            let value: T? = try jsonAdapter.fromJson(configData)
            return value
        } catch {
            // Note: This is very important to log here. When `activate()` is called, it checks all of the values to see if they are working and this logging is done when a deserialization error happens.
            logger.errorOccurred(error)

            // If there was a default value set and it could not parse, then we cannot run the app as the app depends on it. Unit tests should catch this so no need to worry.
            // If no default, then logging the error and returning nil should be fine.
            if key.hasDefeaultValue {
                fatalError(error.localizedDescription)
            } else {
                return nil
            }
        }
    }
}

extension FirebaseRemoteConfig {
    /*
     If your value is non-optional, call it like any other property but `!` at the end.
     */

    var reposCta: CTA? {
        getObjOrNil(key: .reposCta)
    }
}

// MARK: UI testing helper class

class UIHelperRemoteConfig: FirebaseRemoteConfig {
    typealias Store = [RemoteConfigKey: String]

    private var store: Store = [:]

    init() {
        super.init(logger: DI.shared.inject(.activityLogger), environment: DI.shared.inject(.environment), jsonAdapter: DI.shared.inject(.jsonAdapter), stringReplaceUtil: DI.shared.inject(.stringReplaceUtil), keyValueStorage: DI.shared.inject(.keyValueStorage), fileStorage: DI.shared.inject(.fileStorage))
    }

    func set(_ storeValues: Store) {
        storeValues.forEach { newValue in
            store[newValue.key] = newValue.value
        }
    }

    override func fetch(onComplete: ((Result<Void, Error>) -> Void)?) {
        onComplete?(Result.success(Void()))
    }

    override func getStringFromRemoteConfig(key: RemoteConfigKey) -> String? {
        guard store.keys.contains(key) else {
            return nil
        }

        return store[key]
    }
}
