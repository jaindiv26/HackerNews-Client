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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let homeViewController = HomeViewController()
        let bookmarkViewController = BookmarkViewController()
        
        let homeTabItem = UITabBarItem()
        homeTabItem.title = "Home"
        homeTabItem.image = UIImage(named: "home")
        
        let bookmarkTabItem = UITabBarItem()
        bookmarkTabItem.title = "Bookmark"
        bookmarkTabItem.image = UIImage(named: "bookmark")
        
        homeViewController.tabBarItem = homeTabItem
        bookmarkViewController.tabBarItem = bookmarkTabItem
        
        let tabBarList = [homeViewController, bookmarkViewController]
        
        viewControllers = tabBarList
     }
}
