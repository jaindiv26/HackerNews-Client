//
//  HNViewModel.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation

class HomeViewModel: StoryBaseViewModel {
    
    private var topStoriesDataTask: URLSessionDataTask?
    
    override func getData() {
        super.getData()
        guard let url = URLComponents(string: Constants.topStoriesEndpoint)?.url else {
            return
        }
        let request = URLRequest(url: url)
        topStoriesDataTask?.cancel()
        topStoriesDataTask = URLSession(configuration: .default).dataTask(with: request, completionHandler: {
            [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                self?.dataFetchingFailed(withError: error)
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                guard let ids = jsonResponse as? [Int] else {
                    self?.dataFetchingFailed(withError: error)
                    return
                }
                if let strongSelf = self {
                    strongSelf.didFetchIds(ids,
                                           currentCount: 0,
                                           pageCount: HomeViewModel.pageCount)
                }
            }
            catch {
                self?.dataFetchingFailed(withError: error)
            }
        })
        topStoriesDataTask?.resume()
    }
    
    func toggleBookmarkStory(_ storyId: Int) {
        if var bookmarkedIds = UserDefaults.standard.value(forKey: Constants.bookmarkedIds) as? [Int] {
            if let itemToRemoveIndex = bookmarkedIds.firstIndex(of: storyId) {
                bookmarkedIds.remove(at: itemToRemoveIndex)
            }
            else {
                bookmarkedIds.append(storyId)
            }
            UserDefaults.standard.set(bookmarkedIds, forKey: Constants.bookmarkedIds)
        }
        else {
            UserDefaults.standard.set([storyId], forKey: Constants.bookmarkedIds)
        }
    }
    
}
