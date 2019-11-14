//
//  StoryBaseViewModel.swift
//  HackerNews Client
//
//  Created by Divyansh Jain on 13/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation

protocol StoryBaseViewModelDelegate: class {
    
    func reloadData()
    
    func storyBaseViewModel(_ storyBaseViewModel: StoryBaseViewModel,
                            didFailToFetchResultsWithError error: Error?)
    
}

class StoryBaseViewModel {
    
    public static let pageCount: Int = 8
    
    public weak var delegate: StoryBaseViewModelDelegate?
    private var list: [HNModel] = []
    private var filteredList: [HNModel] = []
    private var currentSearchQuery: String?
    private var detailsFetchedFailCount = 0
    private var detailsFetchedFailError: Error?
    
    init(delegate: StoryBaseViewModelDelegate) {
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getData() {
        list.removeAll()
        filteredList.removeAll()
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
        getData()
    }
    
    func doSearch(forQuery query: String?) {
        var searchQuery = query
        searchQuery = searchQuery?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let searchQuery = searchQuery, searchQuery.count >= Constants.searchMinCharacter {
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
            let temp = list.sorted(by: { (m1, m2) -> Bool in
                 m1.time > m2.time
             })
            filteredList.append(contentsOf: temp)
        }
        delegate?.reloadData()
    }
    
    func dataFetchingFailed(withError error: Error?) {
       DispatchQueue.main.async {
           self.delegate?.storyBaseViewModel(self, didFailToFetchResultsWithError: error)
       }
    }
    
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
    
    public func removeItem(forId id: Int) {
        for (index, model) in list.enumerated() {
            if model.id == id {
                list.remove(at: index)
            }
        }
        for (index, model) in filteredList.enumerated() {
            if model.id == id {
                filteredList.remove(at: index)
            }
        }
    }
    
    public func getIndex(forId id: Int) -> Int? {
        for (index, model) in filteredList.enumerated() {
            if model.id == id {
                return index
            }
        }
        return nil
    }
    
    public func updateBookmarkStatus() {
        list.forEach { (model) in
            model.isBookmarked = self.isStoryBookmarked(model.id)
        }
        filteredList.forEach { (model) in
            model.isBookmarked = self.isStoryBookmarked(model.id)
        }
    }
    
    public func isSearching() -> Bool{
        if let currentSearchQuery = currentSearchQuery, !currentSearchQuery.isEmpty {
            return true
        }
        return false
    }
    
}

private extension StoryBaseViewModel {
    
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
    
    func isStoryBookmarked(_ storyId: Int) -> Bool{
        if let bookmarkedIds = UserDefaults.standard.value(forKey: Constants.bookmarkedIds) as? [Int] {
            return bookmarkedIds.contains(storyId)
        }
        return false
    }
    
}
