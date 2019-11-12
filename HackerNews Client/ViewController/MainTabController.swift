//
//  MainTabController.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation
import UIKit

class MainTabController:
    UITabBarController
{
    let searchBar = UISearchBar.init(frame: CGRect.zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let homeViewController = HomeViewController()
        let bookmarkViewController = BookmarkViewController()
        let profileViewController = ProfileViewController()
        
        let homeTabItem = UITabBarItem()
        homeTabItem.title = "Home"
        homeTabItem.image = UIImage(named: "home")
        
        let bookmarkTabItem = UITabBarItem()
        bookmarkTabItem.title = "Bookmark"
        bookmarkTabItem.image = UIImage(named: "bookmark")
        
        let profileTabItem = UITabBarItem()
        profileTabItem.title = "Profile"
        profileTabItem.image = UIImage(named: "user")
        
        homeViewController.tabBarItem = homeTabItem
        bookmarkViewController.tabBarItem = bookmarkTabItem
        profileViewController.tabBarItem = profileTabItem
        
        let tabBarList = [
            UINavigationController.init(rootViewController: homeViewController),
            UINavigationController.init(rootViewController: bookmarkViewController),
            UINavigationController.init(rootViewController: profileViewController)
        ]
        
        viewControllers = tabBarList
    }
}
