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
        
        let backgrounImage = UIImageView.init(frame: CGRect.zero)
        backgrounImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgrounImage)
        backgrounImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgrounImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgrounImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgrounImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        backgrounImage.image = UIImage(named: "launchScreen")
        backgrounImage.contentMode = .scaleAspectFill
        
        let phoneHeight = view.frame.height / 4
        
        let hackerNewsIcon = UIImageView.init(frame: CGRect.zero)
        hackerNewsIcon.translatesAutoresizingMaskIntoConstraints = false
        backgrounImage.addSubview(hackerNewsIcon)
        hackerNewsIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        hackerNewsIcon.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -phoneHeight).isActive = true
        hackerNewsIcon.image = UIImage(named: "logo")
        hackerNewsIcon.contentMode = .scaleAspectFill
        
        let hackerNewsLabel = UILabel.init(frame: CGRect.zero)
        hackerNewsLabel.translatesAutoresizingMaskIntoConstraints = false
        backgrounImage.addSubview(hackerNewsLabel)
        hackerNewsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        hackerNewsLabel.topAnchor.constraint(equalTo: hackerNewsIcon.bottomAnchor, constant: 12).isActive = true
        hackerNewsLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        hackerNewsLabel.text = "HackerFeed"
        hackerNewsLabel.textColor = .white
        
        let hackerNewsQuote = UILabel.init(frame: CGRect.zero)
        hackerNewsQuote.translatesAutoresizingMaskIntoConstraints = false
        backgrounImage.addSubview(hackerNewsQuote)
        hackerNewsQuote.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        hackerNewsQuote.topAnchor.constraint(equalTo: hackerNewsLabel.bottomAnchor, constant: 12).isActive = true
        hackerNewsQuote.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        hackerNewsQuote.text = "Everything you love about tech"
        hackerNewsQuote.textColor = .white
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().clientID = Constants.googleSignInClientId
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        let icon = UIImage(named: "google_icon")!
        
        let googleSignInButton = UIButton.init(frame: CGRect.zero)
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleSignInButton)
        googleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        googleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        googleSignInButton.topAnchor.constraint(equalTo: hackerNewsQuote.bottomAnchor, constant: 50).isActive = true
        googleSignInButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        googleSignInButton.layer.cornerRadius = 22
        googleSignInButton.backgroundColor = .white
        googleSignInButton.setTitle("Get started with Google", for: .normal)
        googleSignInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        googleSignInButton.setTitleColor(.black, for: .normal)
        googleSignInButton.setImage(icon, for: .normal)
        googleSignInButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        googleSignInButton.addTarget(self, action:#selector(startGoogleSignIn), for: .touchUpInside)
    }
    
    @objc func startGoogleSignIn() {
        GIDSignIn.sharedInstance().signIn()
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
        UserDefaults.standard.set(user.profile.givenName, forKey: Constants.userName)
        UserDefaults.standard.set(true, forKey: Constants.isLoggedIn)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = MainTabController()
    }
    
}
