//
//  StoryViewModel.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 13/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation

protocol StoryViewDelegate: class {
    func getComments(_ list: [HNModel])
}

class StoryViewModel {
    
    private var list: [HNModel] = []
    weak var delegate: StoryViewDelegate?
    
    init(delegate: StoryViewDelegate) {
        self.delegate = delegate
    }
    
    func getData(_ ids:[Int]?, currentCount: Int, pageCount: Int) {
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
        
        //Iterate over each id to get it's details
        ids[currentCount..<(currentCount + toFetchCount)].forEach { (postId) in
            dispatchGroup.enter()
            getItemDetails(forItemId: postId, dispactGroup: dispatchGroup)
        }
        
        dispatchGroup.notify(queue: .main) {
            self.delegate?.getComments(self.list)
            self.getData(ids, currentCount: (currentCount + toFetchCount), pageCount: toFetchCount)
        }
    }
    

}

private extension StoryViewModel {
    
    func getItemDetails(forItemId itemId: Int, dispactGroup: DispatchGroup) {
        guard let url = URLComponents(string: Constants.itemEndpoint + "\(itemId).json")?.url else {
            return
        }
        let request = URLRequest(url: url)
        let dataTask = URLSession(configuration: .default).dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonObject = jsonResponse as? NSDictionary else {
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
                    if (!model.comment.isEmpty) {
                        strongSelf.list.append(model)
                    }
                }
                dispactGroup.leave()
            }
            catch {
                dispactGroup.leave()
            }
        }
        dataTask.resume()
    }
}
