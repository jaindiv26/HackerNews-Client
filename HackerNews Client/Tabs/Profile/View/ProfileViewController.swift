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

    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: UIConstants.Image.bgLaunch.rawValue)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: UIConstants.Image.app.rawValue)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "HackerFeed"
        label.textColor = .white
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Everything you love about tech and more"
        label.textColor = .white
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.init(frame: CGRect.zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        createViews()
        setTimer()
    }
}

private extension ProfileViewController {
    
    func createViews() {
        view.addSubview(bgImageView)
        bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bgImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        logoutButton.addTarget(self, action:#selector(didTapLogoutButton), for: .touchUpInside)
        view.addSubview(logoutButton)
        logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: 2*UIConstants.sidePadding).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                     constant: -2*UIConstants.sidePadding).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -2*UIConstants.verticalPadding).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        
        bgImageView.addSubview(subTitleLabel)
        subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subTitleLabel.bottomAnchor.constraint(equalTo: logoutButton.topAnchor,
                                              constant: -4*UIConstants.verticalPadding).isActive = true
        
        bgImageView.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor,
                                          constant: -UIConstants.betweenPadding).isActive = true
    }
    
    func setTimer() {
        _ = Timer.scheduledTimer(timeInterval: 1.0,
                                 target: self,
                                 selector: #selector(didUpdateTimer),
                                 userInfo: nil,
                                 repeats: true)
    }
    
    @objc func didTapLogoutButton() {
        let alertVC = UIAlertController.init(title: "Alert", message: "Do you really want to logout?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "Yes", style: .destructive, handler: { (_) in
            GIDSignIn.sharedInstance().signOut()
            UserDefaults.standard.set(false, forKey: Constants.isLoggedIn)
           
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = WelcomeViewController()
            }
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func didUpdateTimer() {
        setData()
    }
    
    func setData() {
        let hour = Calendar.current.component(.hour, from: Date())
        if (hour >= 0 && hour < 12) {
            if let userName = UserDefaults.standard.value(forKey: Constants.userName) as? String, !userName.isEmpty {
                titleLabel.text = "Good morning, \(userName) !"
            }
            else {
                titleLabel.text = "Good morning"
            }
        }
        else if (hour >= 12 && hour < 18) {
            if let userName = UserDefaults.standard.value(forKey: Constants.userName) as? String, !userName.isEmpty {
                titleLabel.text = "Good afternoon, \(userName) !"
            }
            else {
                titleLabel.text = "Good afternoon"
            }
        }
        else if (hour >= 18 && hour <= 22) {
            if let userName = UserDefaults.standard.value(forKey: Constants.userName) as? String, !userName.isEmpty {
                titleLabel.text = "Good evening, \(userName) !"
            }
            else {
                titleLabel.text = "Good evening"
            }
        }
        
        let currentReadCount = UserDefaults.standard.value(forKey: Constants.userReadCount) as? Int ?? 0
        if currentReadCount == 0 {
            subTitleLabel.text = "You haven't read any stories today"
        }
        else if currentReadCount == 1 {
            subTitleLabel.text = "You read \(currentReadCount) story today"
        }
        else {
            subTitleLabel.text = "You read \(currentReadCount) stories today"
        }
    }
    
}
