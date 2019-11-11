//
//  HNViewModel.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation

protocol ViewModelDelegate {
    func getItemModel(list: [HNModel])
}

class HNViewModel {
    
    var delegate: ViewModelDelegate
    var list: [HNModel] = []
    
    init(delegate: ViewModelDelegate) {
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTopStories() {
        let baseUrl: String = Constants.topStoriesEndpoint
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        
        if let urlComponents = URLComponents(string: baseUrl) {
            
            let request = URLRequest(url: urlComponents.url!)
            
            dataTask =
                defaultSession.dataTask(with: request) { data, response, error in
                    guard let dataResponse = data,
                        error == nil else {
                            print(error?.localizedDescription ?? "Response Error")
                            return }
                    
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        
                        guard let jsonObject = jsonResponse as? [Int] else {
                            return
                        }

                        self.idsFetched(jsonObject, fetchedCount: 0, noOfItemsToFetch: 8)
                    } catch let parsingError {
                        print("Error in parsing data", parsingError)
                    }
            }
            dataTask?.resume()
        }
    }
    
    func idsFetched(_ ids:[Int]?, fetchedCount:Int, noOfItemsToFetch: Int){
        var i = fetchedCount
        var n = noOfItemsToFetch
        
        guard let ids = ids else {
            return
        }
        
        if(ids.count == 0) {
            return
        }
        
        if (fetchedCount == ids.count) {
            return
        }
        
        if (n > ids.count) {
            n = ids.count
        }
        
        if (fetchedCount + n > ids.count) {
            n = ids.count - fetchedCount
        }
        list.removeAll()
        let dispatchGroup = DispatchGroup()
        
        ids[fetchedCount..<(fetchedCount + n)].forEach { (postId) in
            dispatchGroup.enter()
            getItem(id: postId, dispactGroup: dispatchGroup)
        }
        dispatchGroup.notify(queue: .main) {
            i = i + n
            self.delegate.getItemModel(list: self.list)
            self.idsFetched(ids, fetchedCount: i, noOfItemsToFetch: n)
        }
    }
    
    func getItem(id: Int, dispactGroup: DispatchGroup) {
        var model = HNModel.init()
        
        let baseUrl: String = Constants.itemEndpoint + String(id) + ".json"
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        
        if let urlComponents = URLComponents(string: baseUrl) {
            
            let request = URLRequest(url: urlComponents.url!)
            
            dataTask =
                defaultSession.dataTask(with: request) { data, response, error in
                    guard let dataResponse = data,
                        error == nil else {
                            print(error?.localizedDescription ?? "Response Error")
                            return }
                    
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        
                        guard let jsonObject = jsonResponse as? NSDictionary else {
                            return
                        }
                        
                        model = HNModel.init(
                            author: jsonObject["by"] as? String ?? "",
                            commentCount: jsonObject["descendants"] as? Int ?? 0,
                            id: jsonObject["id"] as? Int ?? 0,
                            commentsId: jsonObject["kids"] as? [Int] ?? [],
                            upVotes: jsonObject["score"] as? Int ?? 0,
                            time: jsonObject["time"] as? Int ?? 0,
                            title: jsonObject["title"] as? String ?? "",
                            url: jsonObject["url"]  as? String ?? "",
                            comment: jsonObject["text"] as? String ?? ""
                        )
                        self.list.append(model)
                        dispactGroup.leave()
                    } catch let parsingError {
                        print("Error in parsing data", parsingError)
                    }
            }
            dataTask?.resume()
        }
    }
    
}

