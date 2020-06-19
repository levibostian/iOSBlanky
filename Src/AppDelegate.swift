import Firebase
import IQKeyboardManagerSwift
import RxSwift
import UIKit
import Wendy

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    fileprivate var remoteConfig: RemoteConfigProvider!
    fileprivate var userManager: UserManager!
    fileprivate var eventBusRegister: EventBusRegisterCounter!
    fileprivate var logger: ActivityLogger!
    fileprivate var repositorySyncService: RepositorySyncService!
    fileprivate var startupUtil: StartupUtil!
    fileprivate var environment: Environment!
    fileprivate var backgroundJobRunner: BackgroundJobRunner!
    fileprivate var dataDestroyer: DataDestroyer!
    var themeManager: ThemeManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // We must allow running a host app for unit tests so that we can test keychains in our unit tests. So to prevent the appdelegate from running any code, return early and have tests run assuming appdelegate code did not run.
        // See: https://github.com/kishikawakatsumi/KeychainAccess/issues/399
        if CommandLine.arguments.contains("--unit-testing") {
            return true
        }

        window = UIWindow(frame: UIScreen.main.bounds)

        FirebaseApp.configure() // Do first so crashlytics starts up to record errors.
        logger = DI.shared.activityLogger
        repositorySyncService = DI.shared.repositorySyncService
        startupUtil = DI.shared.startupUtil
        themeManager = DI.shared.themeManager
        environment = DI.shared.environment
        backgroundJobRunner = DI.shared.backgroundJobRunner
        let eventBus = DI.shared.eventBus
        eventBusRegister = EventBusRegisterCounter(eventBus: eventBus)
        eventBusRegister.listener = self
        dataDestroyer = DI.shared.dataDestroyer

        // I don't like having onError all over my code for RxSwift. Errors *should* always be caught and sent through onSuccess. So, catch all onError() calls here and record them to fix later.
        Hooks.defaultErrorHandler = { callback, error in
            self.logger.errorOccurred(error)
            fatalError()
        }

        registerEventListeners()

        UIViewController.swizzle
        themeManager.applyAppTheme(themeManager.currentTheme)

        // Show our launch screen for longer then the default duration of time while we load data and get app asynchronously setup.
        let launchScreenViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "LaunchScreenId")
        showViewController(launchScreenViewController)

        // setup background fetch
        let numberMinutesMinimumToRunBackgroundFetches: Double = 60
        UIApplication.shared.setMinimumBackgroundFetchInterval(numberMinutesMinimumToRunBackgroundFetches * 60) // * 60 as function wants value in seconds
        Wendy.setup(tasksFactory: AppPendingTasksFactory(), collections: [:], debug: environment.isDevelopment)

        Messaging.messaging().delegate = self

        let iqKeyboardManager = IQKeyboardManager.shared
        iqKeyboardManager.shouldResignOnTouchOutside = true
        iqKeyboardManager.enableAutoToolbar = false
        iqKeyboardManager.enable = true

        appStartup()

        return true
    }

    fileprivate func appStartup() {
        startupUtil.runStartupTasks { error in
            if let error = error {
                self.logger.errorOccurred(error)
                fatalError("Cannot startup app with an error in the startup tasks")
            }

            let uiTesting = CommandLine.arguments.contains("--uitesting")

            if uiTesting {
                self.dataDestroyer.destroyAll {
                    UIView.setAnimationsEnabled(false)

                    // Since we are doing data operations, perform them all on background.
                    DispatchQueue.global(qos: .background).async {
                        let moyaMockProvider = MoyaProviderMocker<GitHubService>()
                        let remoteConfigHelper = UIHelperRemoteConfig()

                        let launchStateString: String = ProcessInfo.processInfo.environment["launch_state"]!
                        let jsonAdapter = DI.shared.jsonAdapter
                        let launchArguments: LaunchAppState = try! jsonAdapter.fromJson(launchStateString.data!)
                        let keyValueStorage = DI.shared.keyValueStorage

//                        launchArguments.extras.networkQueue.forEach { queueItem in
//                            if queueItem.isErrorType {
//                                moyaMockProvider.queueNetworkError(queueItem.responseError!.error)
//                            } else {
//                                moyaMockProvider.queueResponse(queueItem.code!, data: queueItem.response!)
//                            }
//                        }
//
//                        launchArguments.extras.keyStorageStringValues.forEach { arg in
//                            let (key, value) = arg
//                            keyValueStorage.setString(value, forKey: key)
//                        }
//                        launchArguments.extras.keyStorageIntValues.forEach { arg in
//                            let (key, value) = arg
//                            keyValueStorage.setInt(value, forKey: key)
//                        }
//
//                        remoteConfigHelper.set(launchArguments.extras.remoteConfig)
//
//                        if let launchUserState = launchArguments.userState {
//                            let userManager = DI.shared.userManager
//
//                            userManager.userId = launchUserState.id
//                        }

                        DI.shared.override(.gitHubMoyaProvider, value: moyaMockProvider.moyaProvider, forType: GitHubMoyaProvider.self)
                        DI.shared.override(.remoteConfigProvider, value: remoteConfigHelper, forType: RemoteConfigProvider.self)

                        DispatchQueue.main.async {
                            self.afterStartupTasks()
                        }
                    }
                }
            } else {
                self.afterStartupTasks()
            }
        }
    }

    func afterStartupTasks() {
        // Activate previously fetched remote config, then kick off new refresh. Important to run in this order!
        let remoteConfig: RemoteConfigProvider = DI.shared.inject(.remoteConfigProvider)

        remoteConfig.activate()
        remoteConfig.fetch(onComplete: nil)

        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()

        // Need to start wendy when app starts up.
        Wendy.shared.runTasks(filter: nil, onComplete: nil)

        registerForPushNotifications() // In case app launches and user has not been asked about push notifications yet.
    }

    fileprivate func getNavigationController(rootViewController: UIViewController) -> UINavigationController {
        BaseNavigationController(rootViewController: rootViewController)
    }

    private func showViewController(_ viewController: UIViewController, animate: Bool = true) {
        let duration = animate ? 0.3 : 0.0

        UIView.transition(with: window!, duration: duration, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }, completion: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        unregisterEventListeners()
    }

    fileprivate func logoutIfExistingUser(onComplete: @escaping OnComplete) {
        let userManager: UserManager = DI.shared.inject(.userManager)

        logger.breadcrumb("Attempting to logout if existing user", extras: [
            "existing_user_logged_in": userManager.isLoggedIn
        ])

        if userManager.isLoggedIn { // Only logout if there is already someone logged in. See notes in README to learn more.
            logger.appEventOccurred(.logout, extras: nil)
            logger.setUserId(id: nil)

            let dataDestroyer: DataDestroyer = DI.shared.inject(.dataDestroyer)

            dataDestroyer.destroyAll {
                onComplete()
            }
        } else {
            onComplete()
        }
    }
}

// MARK: Firebase messaging

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    // Asks user for permission to receive push notifications *and* sets up firebase messaging.
    // Note: Only ask for this when you can (1) register the FCM token with an authenticated user and (2) the user is far enough along in the app that asking them for permission to recieve push notifications is not annoying to ask.
    func registerForPushNotifications() {
        let application = UIApplication.shared

        UNUserNotificationCenter.current().delegate = self

        // I only care to send "data" FCM push notifications to no need to get authorized for alerts
        let authOptions: UNAuthorizationOptions = [] // Options: .alert, .badge, .sound
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })

        application.registerForRemoteNotifications()
    }

    // Firebase FCM token refreshed.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        // If we were sending push notifications via API, we would use this to send the push notification to the server. However, we don't need to do anything to send manually from Firebase console.
        // at any time you need, you can get the current token via: let token = Messaging.messaging().fcmToken
        logger.breadcrumb("FCM token refreshed", extras: [
            "token": fcmToken
        ])

        // Now is also the best time to subscribe to topics.
        Messaging.messaging().subscribe(toTopic: FcmTopicKeys.filesToDownload.value) { error in
            if let error = error {
                self.logger.errorOccurred(error)
            }

            self.logger.appEventOccurred(.pushNotificationTopicSubscribed, extras: [
                .name: FcmTopicKeys.filesToDownload.value
            ])
        }
    }

    // APN (Apple push notification token. Different from Firebase FCM token) token received. We do not need to do anything with it because Firebase does this automatically for us with swizzling.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {}

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logger.breadcrumb("received push notification", extras: [
            "raw": userInfo.description
        ])

        guard let dataNotification = NotificationUtil.parseDataNotification(from: userInfo) else {
            logger.appEventOccurred(.pushNotificationReceived, extras: [
                .type: "ui"
            ])

            completionHandler(.noData)
            return
        }

        logger.appEventOccurred(.pushNotificationReceived, extras: [
            .type: "data"
        ])

        backgroundJobRunner.handleDataNotification(dataNotification, onComplete: completionHandler)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {}

    // FCM push notification with a "notification" payload attached will call this *if* app in foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert) // If a push notification is received while app is in foreground, I want to still have it show up.
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            return // The user dismissed the notification without taking action
        } else if response.actionIdentifier == UNNotificationDefaultActionIdentifier { // User selected the notification to launch the app. They *did not* use one of the custom action buttons on the action, just the default action of selecting the notification.
        }
    }
}

// MARK: Firebase Dynamic links

/**
 The code below contains code from [the official Firebase docs](https://firebase.google.com/docs/dynamic-links/ios/receive) to parse the Dynamic Link out of each function. Here is an example of a full Dynamic Link sent by the API: `https://XXX.page.link/?link=https%3A%2F%2Fapp.foo.com%2F%3F_token%3D123`. Firebase SDK does some nice things for us to parse this for us. It is then up to us to take the URL after `?link=`, parse that, then act on it. This Dynamic Link pattern is what the API always creates. So the code below works hard to get the app URL for us (`https://app.foo.com/?...`) and then pass that to a processor to help us act on it.
 */
extension AppDelegate {
    // This method is called when your app receives a link on iOS 8 and older, and when your app is opened for the first time after installation on any version of iOS. Also to handle links received through your app's custom URL scheme.
    // If the Dynamic Link isn't found on your app's first launch (on any version of iOS), this method will be called with the FIRDynamicLink's url set to nil, indicating that the SDK failed to find a matching pending Dynamic Link.
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        var handled = false
        if let firebaseDynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)?.url {
            handled = handleDeepLink(firebaseDynamicLink)
        }

        return handled
    }

    // Handle links received as [Universal Links](https://developer.apple.com/library/ios/documentation/General/Conceptual/AppSearch/UniversalLinks.html) when the app is already installed (on iOS 9 and newer)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let deepLinkUrl = userActivity.webpageURL else { // Firebase Dynamic Links SDK uses the `webpageURL` so, it must be present to even continue.
            return false
        }

        var handled = false

        handled = DynamicLinks.dynamicLinks().handleUniversalLink(deepLinkUrl) { dynamiclink, error in
            if let error = error {
                self.logger.errorOccurred(error)
            }
            if let dynamicLink = dynamiclink?.url {
                _ = self.handleDeepLink(dynamicLink)
            }
        }

        /**
         The following pieces of code below are commented out because [the official Firebase docs](https://firebase.google.com/docs/dynamic-links/ios/receive) does not include the below code so I believe it is not needed. However, if ever in the situation where this code would be useful, having it here easily available as potential solutions to the problem would be handy. So, the code sits here.
         */

        // Firebase dynamic links works with both URL schemes and iOS Universal Links. `handleUniversalLink()` may not catch every time your app launches from a deep link so, we may need to parse it ourselves manually.
//        if !handled {
//            handled = self.handleDeepLink(deepLinkUrl)
//        }
        // If false, iOS should open the URL in a browser. This dynamic link could be a Firebase short URL that we need to expand in order to pick out the query parameters. So, let's assume iOS will take care of that for us if we return false from this function but if not, do this hack to re-open the short link to expand it and re-open our app.
        // UIApplication.shared.open(deepLink, options: [:], completionHandler: nil)
        return handled
    }

    fileprivate func handleDeepLink(_ deepLink: URL) -> Bool {
        logger.appEventOccurred(.openedDynamicLink, extras: nil)

        guard let action = DynamicLinksProcessor.getActionFromDynamicLink(deepLink) else {
            return false
        }

        switch action {
        case .tokenExchange(let token):
            logoutIfExistingUser {
                self.appCoordinator?.startUserLogin(token: token)
            }
        }

        return true
    }
}

// MARK: Register listeners

extension AppDelegate: EventBusEventListener {
    fileprivate func registerEventListeners() {
        logger.breadcrumb("registering event listeners", extras: nil)

        eventBusRegister.register(event: .logout)
    }

    fileprivate func unregisterEventListeners() {
        logger.breadcrumb("unregistering event listeners", extras: nil)

        eventBusRegister.unregister(event: .logout)
    }

    func eventBusEvent(_ event: EventBusEvent, extras: EventBusExtras?) {
        logger.breadcrumb("event bus event recieved. name: \(event.name)", extras: extras)

        switch event {
        case .logout:
            logoutIfExistingUser {
                self.afterStartupTasks()
            }
        default: break
        }
    }
}

// MARK: Background syncing

extension AppDelegate {
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        registerEventListeners()

        backgroundJobRunner.runPeriodicBackgroundJobs { result in
            self.unregisterEventListeners()

            completionHandler(result)
        }
    }
} // swiftlint:disable:this file_length
