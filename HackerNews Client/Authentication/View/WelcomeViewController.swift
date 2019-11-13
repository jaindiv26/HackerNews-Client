//
//  WelcomeViewController.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 12/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import UIKit
import GoogleSignIn

class WelcomeViewController: UIViewController {
    
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
    
    private lazy var googleSignInButton: UIButton = {
        let button = UIButton.init(frame: CGRect.zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.backgroundColor = .white
        button.setTitle("Get started with Google", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: UIConstants.Image.google.rawValue), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: UIConstants.sidePadding,
                                              left: UIConstants.sidePadding,
                                              bottom: UIConstants.sidePadding,
                                              right: UIConstants.sidePadding)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        createViews()
        setUpGoogleSignIn(GIDSignIn.sharedInstance())
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
}

private extension WelcomeViewController {
    
    func createViews() {
        view.addSubview(bgImageView)
        bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bgImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        googleSignInButton.addTarget(self, action:#selector(didTapGoogleSignInButton), for: .touchUpInside)
        view.addSubview(googleSignInButton)
        googleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: 2*UIConstants.sidePadding).isActive = true
        googleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                     constant: -2*UIConstants.sidePadding).isActive = true
        googleSignInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -2*UIConstants.verticalPadding).isActive = true
        googleSignInButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        
        bgImageView.addSubview(subTitleLabel)
        subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subTitleLabel.bottomAnchor.constraint(equalTo: googleSignInButton.topAnchor,
                                              constant: -4*UIConstants.verticalPadding).isActive = true
        
        bgImageView.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor,
                                           constant: -UIConstants.betweenPadding).isActive = true
        
        bgImageView.addSubview(topImageView)
        topImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor,
                                             constant: -UIConstants.verticalPadding).isActive = true
    }
    
    func setUpGoogleSignIn(_ gIDSignIn: GIDSignIn) {
        gIDSignIn.presentingViewController = self
        gIDSignIn.clientID = Constants.googleSignInClientId
        gIDSignIn.delegate = self
    }
    
    @objc func didTapGoogleSignInButton() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func googleSignInSuccessfull(forGoogleUser user: GIDGoogleUser) {
        UserDefaults.standard.set(user.profile.givenName, forKey: Constants.userName)
        UserDefaults.standard.set(true, forKey: Constants.isLoggedIn)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = MainTabController()
        }
    }
    
}

extension WelcomeViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!,
              didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            var errorMessage = error.localizedDescription
            if errorMessage.isEmpty {
                errorMessage = "Something went wrong!"
            }
            let alertVC = UIAlertController.init(title: "Error", message: errorMessage, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
            return
        }
        googleSignInSuccessfull(forGoogleUser: user)
    }
    
}
