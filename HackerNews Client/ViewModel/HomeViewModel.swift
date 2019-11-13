//
//  HNViewModel.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: class {
    
    func reloadData()
    
    func homeViewModel(_ homeViewModel: HomeViewModel, didFailToFetchResultsWithError error: Error?)
    
}

class HomeViewModel {
    
    private static let pageCount: Int = 8
    
    weak var delegate: HomeViewModelDelegate?
    private var list: [HNModel] = []
    private var filteredList: [HNModel] = []
    private var currentSearchQuery: String?
    private var topStoriesDataTask: URLSessionDataTask?
    private var detailsFetchedFailCount = 0
    private var detailsFetchedFailError: Error?
    
    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getData() {
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
    
    func getTotalItems() -> Int {
        return filteredList.count
    }
    
    func getItem(forRow row:Int) -> HNModel? {
        if row < 0 || row >= filteredList.count {
            return nil
        }
        return filteredList[row]
    }
    
    func didClickItem() {
        let currentReadCount = UserDefaults.standard.value(forKey: Constants.userReadCount) as? Int
        UserDefaults.standard.set((currentReadCount ?? 0) + 1, forKey: Constants.userReadCount)
    }
    
    func doRefresh() {
        list.removeAll()
        filteredList.removeAll()
        getData()
    }
    
    func doSearch(forQuery query: String?) {
        var searchQuery = query
        searchQuery = searchQuery?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let searchQuery = searchQuery, searchQuery.count > 1 {
            currentSearchQuery = searchQuery
            let searchedList = list.filter {
                let searchKey = $0.title.lowercased() + $0.url.lowercased()
                return searchKey.contains(searchQuery)
            }
            filteredList.removeAll()
            filteredList.append(contentsOf: searchedList)
        }
        else {
            currentSearchQuery = nil
            filteredList.removeAll()
            filteredList.append(contentsOf: list)
        }
        delegate?.reloadData()
    }
    
}

private extension HomeViewModel {
    
    func didFetchIds(_ ids:[Int]?, currentCount: Int, pageCount: Int) {
        guard let ids = ids, !ids.isEmpty else {
            return
        }
        //All items fetched
        if currentCount == ids.count {
            return
        }
        var toFetchCount = pageCount
        
        if toFetchCount > ids.count {
            toFetchCount = ids.count
        }
        
        if currentCount + toFetchCount > ids.count {
            toFetchCount = ids.count - currentCount
        }
        
        let dispatchGroup = DispatchGroup()
        
        //Reset failure vars
        detailsFetchedFailCount = 0
        detailsFetchedFailError = nil
        
        //Iterate over each id to get it's details
        ids[currentCount..<(currentCount + toFetchCount)].forEach { (postId) in
            dispatchGroup.enter()
            getItemDetails(forItemId: postId, dispactGroup: dispatchGroup)
        }
        
        dispatchGroup.notify(queue: .main) {
            if self.detailsFetchedFailCount > 0 {
                self.dataFetchingFailed(withError: self.detailsFetchedFailError)
            }
            else {
                self.list.forEach { (model) in
                    model.isBookmarked = self.isStoryBookmarked(model.id)
                }
                self.doSearch(forQuery: self.currentSearchQuery)
                self.didFetchIds(ids, currentCount: (currentCount + toFetchCount), pageCount: toFetchCount)
            }
        }
    }
    
    func getItemDetails(forItemId itemId: Int, dispactGroup: DispatchGroup) {
        guard let url = URLComponents(string: Constants.itemEndpoint + "\(itemId).json")?.url else {
            return
        }
        let request = URLRequest(url: url)
        let dataTask = URLSession(configuration: .default).dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                if let strongSelf = self {
                    strongSelf.detailsFetchedFailError = error
                    strongSelf.detailsFetchedFailCount += 1
                }
                dispactGroup.leave()
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonObject = jsonResponse as? NSDictionary else {
                    if let strongSelf = self {
                        strongSelf.detailsFetchedFailError = error
                        strongSelf.detailsFetchedFailCount += 1
                    }
                    dispactGroup.leave()
                    return
                }
                let model = HNModel.init(author: jsonObject["by"] as? String ?? "",
                                         commentCount: jsonObject["descendants"] as? Int ?? 0,
                                         id: jsonObject["id"] as? Int ?? 0,
                                         commentsId: jsonObject["kids"] as? [Int] ?? [],
                                         upVotes: jsonObject["score"] as? Int ?? 0,
                                         time: jsonObject["time"] as? Int ?? 0,
                                         title: jsonObject["title"] as? String ?? "",
                                         url: jsonObject["url"]  as? String ?? "",
                                         comment: jsonObject["text"] as? String ?? "")
                model.comment = model.comment.html2String
                if let strongSelf = self {
                    strongSelf.list.append(model)
                }
                dispactGroup.leave()
            }
            catch {
                if let strongSelf = self {
                    strongSelf.detailsFetchedFailError = error
                    strongSelf.detailsFetchedFailCount += 1
                }
                dispactGroup.leave()
            }
        }
        dataTask.resume()
    }
    
    func dataFetchingFailed(withError error: Error?) {
        DispatchQueue.main.async {
            self.delegate?.homeViewModel(self, didFailToFetchResultsWithError: error)
        }
    }
    
    func isStoryBookmarked(_ storyId: Int) -> Bool{
        if let bookmarkedIds = UserDefaults.standard.value(forKey: Constants.bookmarkedIds) as? [Int] {
            return bookmarkedIds.contains(storyId)
        }
        return false
    }
    
}
