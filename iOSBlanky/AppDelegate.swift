//
//  AppDelegate.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    fileprivate var remoteConfig: RemoteConfigProvider!
    fileprivate var userManager: UserManager!
    fileprivate var logger: ActivityLogger!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        self.logger = Di.inject.activityLogger
        self.remoteConfig = Di.inject.remoteConfig
        self.userManager = Di.inject.userManager

        // I don't like having onError all over my code for RxSwift. Errors *should* always be caught and sent through onSuccess. So, catch all onError() calls here and record them to fix later.
        Hooks.defaultErrorHandler = { callback, error in
            self.logger.errorOccurred(error)
            fatalError()
        }

        Messaging.messaging().delegate = self
        remoteConfig.fetch()

        window = UIWindow(frame: UIScreen.main.bounds)

        let iqKeyboardManager = IQKeyboardManager.shared
        iqKeyboardManager.shouldResignOnTouchOutside = true
        iqKeyboardManager.enableAutoToolbar = false
        iqKeyboardManager.enable = true

        goToMainPartOfApp()

        registerForPushNotifications() // In case app launches and user has not been asked about push notifications yet.
        
        return true
    }

    fileprivate func goToMainPartOfApp() {
        let viewController = MainViewController()

        self.window?.rootViewController = getNavigationController(rootViewController: viewController)
        self.window?.makeKeyAndVisible()
    }

    fileprivate func getNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let view = UINavigationController(rootViewController: rootViewController)

        view.navigationBar.barTintColor = UIColor.gray
        view.navigationBar.tintColor = UIColor.white
        view.navigationBar.isTranslucent = false
        view.navigationBar.barStyle = UIBarStyle.black // makes status bar text color white.

        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
        view.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key: Any]

        return view
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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

// MARK: Firebase messaging
extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {

    // Asks user for permission to receive push notifications *and* sets up firebase messaging.
    // Note: Only ask for this when you can (1) register the FCM token with an authenticated user and (2) the user is far enough along in the app that asking them for permission to recieve push notifications is not annoying to ask.
    func registerForPushNotifications() {
        if userManager.isUserLoggedIn() {
            let application = UIApplication.shared

            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge] // Options: .alert, .badge, .sound
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })

            application.registerForRemoteNotifications()
        }
    }

    // Firebase FCM token refreshed.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        // If we were sending push notifications via API, we would use this to send the push notification to the server. However, we don't need to do anything to send manually from Firebase console.
        // at any time you need, you can get the current token via: let token = Messaging.messaging().fcmToken
    }

    // APN (Apple push notification token. Different from Firebase FCM token) token received. We do not need to do anything with it because Firebase does this automatically for us with swizzling.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }

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
extension AppDelegate {

    // Used whn DynamicLinks are clicked on the device when your app is opened for the first time after installation on any version of iOS.
    // Also, used when a link with your custom URL scheme is called: yourappname://foo
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if let firebaseDynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleFirebaseDynamicLink(firebaseDynamicLink)
            return true
        }

        // Let others handle the dynamic link as well, here.

        return false
    }

    // Used when DynamicLinks are clicked on the device and your app is already installed.
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            if let error = error {
                self.logger.errorOccurred(error)
            }
            if let dynamicLink = dynamiclink {
                self.handleFirebaseDynamicLink(dynamicLink)
            }
        }

        return handled
    }

    fileprivate func handleFirebaseDynamicLink(_ firebaseDynamicLink: DynamicLink) {
        guard let dynamicLink = firebaseDynamicLink.url else {
            return
        }

        if let authTokenAccessToken = dynamicLink.getQueryParamValue("auth_token_access_token") {
            // handle case where user wants to login. Send up accessToken to server to exchange it for an access token.
        } else {
            // more then likely, this dynamic link is a short URL that we need to expand in order to pick out the query parameters. So, do this hack to re-open the short link to expand it and re-open our app.
            UIApplication.shared.open(dynamicLink, options: [:], completionHandler: nil)
        }
    }

}
