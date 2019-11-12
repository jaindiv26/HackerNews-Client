//
//  ProfileTabViewController.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 12/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton.init(frame: CGRect.zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        button.addTarget(self, action:#selector(logout), for: UIControl.Event.touchUpInside)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
    }
    
    @objc func logout() {
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.set(false, forKey: Constants.isLoggedIn)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = WelcomeViewController()
    }
}
