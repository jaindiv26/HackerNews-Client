//
//  AppDelegate.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        var nav = UINavigationController.init()
        
        if (UserDefaults.standard.value(forKey: Constants.isLoggedIn) as? Bool ?? false) {
            nav = UINavigationController.init(rootViewController: MainTabController())
        } else {
            nav = UINavigationController.init(rootViewController: WelcomeViewController())
        }

        nav.setNavigationBarHidden(true, animated: false)
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.backgroundColor = .clear
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

