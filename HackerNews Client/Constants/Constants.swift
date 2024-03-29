//
//  Constants.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import UIKit

struct Constants {
    
    public static let apiBaseURL = "https://hacker-news.firebaseio.com/"
    public static let apiVersion = "v0"
    public static let topStoriesEndpoint = apiBaseURL + apiVersion + "/topstories.json"
    public static let itemEndpoint = apiBaseURL + apiVersion + "/item/"
    public static let domainIconEndpoint = "https://www.google.com/s2/favicons?domain="
    public static let googleSignInClientId = "1066366793735-il4td26mn1hm3t645deborhq1kamecki.apps.googleusercontent.com"
    public static let isLoggedIn = "isLoggedIn"
    public static let bookmarkedIds = "bookmarkedIds"
    public static let userName = "userName"
    public static let userReadCount = "userReadCount"
    public static let sharingMessage = "Check out this story"
    public static let bookmarkRemovedNotificationKey = "bookmarkRemovedNotificationKey"
    public static let bookmarkUpdatedNotificationKey = "bookmarkUpdatedNotificationKey"
    public static let searchMinCharacter = 2
}

struct UIConstants {

    public static let sidePadding: CGFloat = 12
    public static let verticalPadding: CGFloat = 12
    public static let betweenPadding: CGFloat = 4
    public static let buttonHeight: CGFloat = 44
    public static let cornerRadius: CGFloat = 8
    public static let iconSize: CGSize = .init(width: 24, height: 24)
    
    enum Image: String {
        case feedOutline = "feed_outline"
        case feedFilled = "feed_filled"
        case bookmarkOutline = "bookmark_outline"
        case bookmarkFilled = "bookmark_filled"
        case profileOutline = "profile_outline"
        case profileFilled = "profile_filled"
        case shareOutline = "share_outline"
        case google = "google_icon"
        case app = "logo"
        case bgLaunch = "launchScreen"
    }
    
}
