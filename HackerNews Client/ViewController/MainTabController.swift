//
//  MainTabController.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation
import UIKit

class MainTabController: UITabBarController{
    
    enum TabBarItemType {
        case home
        case bookmarks
        case profile
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        createViews()
    }
}

private extension MainTabController {
    
    func createViews() {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = getTabBarItem(forType: .home)
               
        let bookmarkViewController = BookmarkViewController()
        bookmarkViewController.tabBarItem = getTabBarItem(forType: .bookmarks)
               
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = getTabBarItem(forType: .profile)
        
        let tabBarList = [
            UINavigationController.init(rootViewController: homeViewController),
            UINavigationController.init(rootViewController: bookmarkViewController),
            UINavigationController.init(rootViewController: profileViewController)
        ]
        viewControllers = tabBarList
    }
    
    func getTabBarItem(forType type: TabBarItemType) -> UITabBarItem {
        switch type {
        case .home:
            let tabItem = UITabBarItem()
            tabItem.title = "Home"
            tabItem.image = UIImage(named: UIConstants.Image.feedOutline.rawValue)
            tabItem.selectedImage = UIImage(named: UIConstants.Image.feedFilled.rawValue)
            return tabItem
        case .bookmarks:
            let tabItem = UITabBarItem()
            tabItem.title = "Bookmark"
            tabItem.image = UIImage(named: UIConstants.Image.bookmarkOutline.rawValue)
            tabItem.selectedImage = UIImage(named: UIConstants.Image.bookmarkFilled.rawValue)
            return tabItem
        case .profile:
            let tabItem = UITabBarItem()
            tabItem.title = "Profile"
            tabItem.image = UIImage(named: UIConstants.Image.profileOutline.rawValue)
            tabItem.selectedImage = UIImage(named: UIConstants.Image.profileFilled.rawValue)
            return tabItem
        }
    }
    
    
}
