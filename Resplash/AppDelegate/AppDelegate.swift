//
//  AppDelegate.swift
//  Resplash
//
//  Created by Eric Ziegler on 12/14/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // activate watch if possible
        if WatchManager.shared.isSupported == false {
            print("WCSession not supported.")
        }
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

