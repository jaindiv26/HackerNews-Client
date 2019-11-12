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
    
    let userGreeting = UILabel.init(frame: CGRect.zero)
    let noOfStoriesRead = UILabel.init(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let backgrounImage = UIImageView.init(frame: CGRect.zero)
        backgrounImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgrounImage)
        backgrounImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgrounImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgrounImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgrounImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        backgrounImage.image = UIImage(named: "launchScreen")
        backgrounImage.contentMode = .scaleAspectFill
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector(("setUserGreeting")), userInfo: nil, repeats: true)
        
        userGreeting.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userGreeting)
        userGreeting.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        userGreeting.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        userGreeting.textColor = .white
        userGreeting.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        setGreeting()
        
        noOfStoriesRead.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noOfStoriesRead)
        noOfStoriesRead.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        noOfStoriesRead.topAnchor.constraint(equalTo: userGreeting.bottomAnchor, constant: 12).isActive = true
        noOfStoriesRead.textColor = .white
        noOfStoriesRead.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        let logoutButton = UIButton.init(frame: CGRect.zero)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -95).isActive = true
        logoutButton.addTarget(self, action:#selector(logout), for: UIControl.Event.touchUpInside)
        logoutButton.backgroundColor = .red
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.borderColor = UIColor.black.cgColor
        logoutButton.layer.cornerRadius = 16
    }
    
    func setGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        var time: String?
        let user = UserDefaults.standard.value(forKey: Constants.userName) as? String
        
        if (hour > 0 && hour < 12) {
            time = "Good morning, " + user!
        }
        
        if (hour > 12 && hour < 18) {
            time = "Good afternoon, " + user!
        }
        
        if (hour > 18 && hour < 21) {
            time = "Good evening, " + user!
        }
        
        if (hour > 21) {
            time = "Good night, " + user!
        }
        
        userGreeting.text = time
        
        let currentReadCount = UserDefaults.standard.value(forKey: Constants.userReadCount) as? Int ?? 0
        if (currentReadCount == 0) {
            noOfStoriesRead.text = "You haven't read any stories today"
        }
        if (currentReadCount == 1) {
            noOfStoriesRead.text = "You you read " + String(currentReadCount) + " story today"
        }
        else {
            noOfStoriesRead.text = "You you read " + String(currentReadCount) + " stories today"
        }
    }
    
    @objc func setUserGreeting() {
        setGreeting()
    }
    
    @objc func logout() {
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.set(false, forKey: Constants.isLoggedIn)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = WelcomeViewController()
    }
}
