//
//  BookmarkViewModel.swift
//  HackerNews Client
//
//  Created by Divyansh Jain on 13/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation

class BookmarkViewModel: StoryBaseViewModel {
 
    override func getData() {
        super.getData()
        if let bookmarkedIds = UserDefaults.standard.value(forKey: Constants.bookmarkedIds) as? [Int], !bookmarkedIds.isEmpty {
            didFetchIds(bookmarkedIds,
            currentCount: 0,
            pageCount: HomeViewModel.pageCount)
        }
        else {
            delegate?.reloadData()
        }
    }
    
    func didRemoveBookmark(_ model: HNModel) {
        removeItem(forId: model.id)
        removeBookmarkStory(model.id)
    }
    
    func removeBookmarkStory(_ storyId: Int) {
        if var bookmarkedIds = UserDefaults.standard.value(forKey: Constants.bookmarkedIds) as? [Int] {
            if let itemToRemoveIndex = bookmarkedIds.firstIndex(of: storyId) {
                bookmarkedIds.remove(at: itemToRemoveIndex)
                UserDefaults.standard.set(bookmarkedIds, forKey: Constants.bookmarkedIds)
            }
        }
    }
    
}
