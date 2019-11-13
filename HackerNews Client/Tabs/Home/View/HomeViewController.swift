//
//  ViewController.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import UIKit

class HomeViewController: StoryBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search for articles, websites..."
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didRemoveBookmark),
                                               name: NSNotification.Name.init(Constants.bookmarkRemovedNotificationKey),
                                               object: nil)
    }
    
    @objc func didRemoveBookmark() {
        viewModel?.updateBookmarkStatus()
        tableView.reloadData()
    }

    override func topStoriesCell(_ topStoriesCell: TopStoriesCell,
                                 didTapBookmarkButtonForData data: HNModel) {
        guard let indexUpdated = viewModel?.getIndex(forId: data.id) else {
            return
        }
        if let viewModel = viewModel as? HomeViewModel {
            viewModel.toggleBookmarkStory(data.id)
        }
        data.isBookmarked = !data.isBookmarked
        tableView.reloadRows(at: [IndexPath.init(row: indexUpdated, section: 0)], with: .automatic)
        
        NotificationCenter.default.post(name: NSNotification.Name.init(Constants.bookmarkUpdatedNotificationKey),
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
            showErrorView("No top stories yet!")
            hideRetryButton(true)
        }
    }
    
    override func getViewModel() -> StoryBaseViewModel? {
        return HomeViewModel.init(delegate: self)
    }
    
}
