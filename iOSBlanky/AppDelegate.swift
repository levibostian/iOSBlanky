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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        window = UIWindow(frame: UIScreen.main.bounds)

        let iqKeyboardManager = IQKeyboardManager.shared
        iqKeyboardManager.shouldResignOnTouchOutside = true
        iqKeyboardManager.enableAutoToolbar = false
        iqKeyboardManager.enable = true

        goToMainPartOfApp()
        
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
