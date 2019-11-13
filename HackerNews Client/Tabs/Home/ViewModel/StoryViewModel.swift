//
//  StoryViewModel.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 13/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation

class StoryViewModel: StoryBaseViewModel {
    
    private let commentIds:[Int]
    private var list: [HNModel] = []
    
    public init(commentIds:[Int], delegate: StoryBaseViewModelDelegate) {
        self.commentIds = commentIds
        super.init(delegate: delegate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getData() {
        super.getData()
        didFetchIds(commentIds,
        currentCount: 0,
        pageCount: HomeViewModel.pageCount)
    }
}
