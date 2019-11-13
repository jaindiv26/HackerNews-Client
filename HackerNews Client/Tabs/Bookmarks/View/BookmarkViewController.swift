//
//  BookmarkViewController.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import UIKit

class BookmarkViewController: StoryBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search within your bookmarks..."
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdateBookmark),
                                               name: NSNotification.Name.init(Constants.bookmarkUpdatedNotificationKey),
                                               object: nil)
    }
    
    @objc func didUpdateBookmark() {
        viewModel?.getData()
    }

    override func topStoriesCell(_ topStoriesCell: TopStoriesCell,
                                 didTapBookmarkButtonForData data: HNModel) {
        guard let indexUpdated = viewModel?.getIndex(forId: data.id) else {
            return
        }
        if let viewModel = viewModel as? BookmarkViewModel {
            viewModel.didRemoveBookmark(data)
        }
        data.isBookmarked = !data.isBookmarked
        tableView.deleteRows(at: [IndexPath.init(row: indexUpdated, section: 0)], with: .automatic)
        NotificationCenter.default.post(name: NSNotification.Name.init(Constants.bookmarkRemovedNotificationKey),
                                        object: nil)
    }
    
    override func reloadData() {
        super.reloadData()
        if let itemCount = viewModel?.getTotalItems(), itemCount > 0 {
            hideErrorView()
        }
        else if viewModel?.isSearching() ?? false {
            showErrorView("🔍\nWe cannot find the item you are searching for, maybe a little spelling mistake?")
            hideRetryButton(true)
        }
        else {
            showErrorView("🔖\nYou haven't bookmarked any items yet")
            hideRetryButton(true)
        }
    }
    
    override func getViewModel() -> StoryBaseViewModel? {
        return BookmarkViewModel.init(delegate: self)
    }
    
}
