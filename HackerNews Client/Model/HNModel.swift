
//
//  Model.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation

class HNModel {
    
    var author: String = ""
    var commentCount: Int = 0
    var id: Int = 0
    var commentsId: [Int] = []
    var upVotes: Int = 0
    var time: Int = 0
    var title: String = ""
    var url: String = ""
    var comment: String = ""
    var isBookmarked: Bool = false
    
    init() {
        
    }
    
    init (
        author: String,
        commentCount: Int,
        id: Int,
        commentsId: [Int],
        upVotes: Int,
        time: Int,
        title: String,
        url: String,
        comment: String
    ) {
        self.author = author
        self.commentCount = commentCount
        self.id = id
        self.commentsId = commentsId
        self.upVotes = upVotes
        self.time = time
        self.title = title
        self.url = url
        self.comment = comment
    }
    
}

