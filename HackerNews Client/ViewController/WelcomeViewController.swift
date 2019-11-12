//
//  WelcomeViewController.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 12/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class WelcomeViewController: UIViewController, GIDSignInDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().clientID = Constants.googleSignInClientId
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        let googleSignInButton = GIDSignInButton.init(frame: CGRect.zero)
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleSignInButton)
        googleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        googleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        googleSignInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        UserDefaults.standard.set(true, forKey: Constants.isLoggedIn)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = MainTabController()
    }
    
}
