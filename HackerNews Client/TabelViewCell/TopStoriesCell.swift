//
//  TopStoriesCell.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation
import UIKit

class TopStoriesCell: UITableViewCell {
    
    let domainIcon = UIImageView.init(frame: CGRect.zero)
    let domainText = UILabel.init(frame: CGRect.zero)
    let title = UILabel.init(frame: CGRect.zero)
    let author = UILabel.init(frame: CGRect.zero)
    let timestamp = UILabel.init(frame: CGRect.zero)
    let upvotes = UILabel.init(frame: CGRect.zero)
    let commentsCount = UILabel.init(frame: CGRect.zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        domainIcon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(domainIcon)
        domainIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        domainIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        domainIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        domainIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        domainIcon.contentMode = .scaleAspectFit
        
        domainText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(domainText)
        domainText.leadingAnchor.constraint(equalTo: domainIcon.trailingAnchor, constant: 12).isActive = true
        domainText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        domainText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        domainText.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        domainText.textColor = .darkGray
        
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        title.topAnchor.constraint(equalTo: domainText.bottomAnchor, constant: 12).isActive = true
        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        
        author.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(author)
        author.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        author.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12).isActive = true
        author.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        author.textColor = .black
        
        timestamp.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timestamp)
        timestamp.leadingAnchor.constraint(equalTo: author.trailingAnchor, constant: 12).isActive = true
        timestamp.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12).isActive = true
        timestamp.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        timestamp.textColor = .darkGray
        
        upvotes.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(upvotes)
        upvotes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        upvotes.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 12).isActive = true
        upvotes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        upvotes.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        upvotes.textColor = .darkGray
        
        commentsCount.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(commentsCount)
        commentsCount.leadingAnchor.constraint(equalTo: upvotes.trailingAnchor, constant: 12).isActive = true
        commentsCount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        commentsCount.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        commentsCount.textColor = .darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(model: HNModel) {
        let domain = URL(string: model.url)?.host
        let url = URL(string: Constants.domainIconEndpoint + domain!)
        
        do {
            let data = try Data(contentsOf: url!)
            domainIcon.image = UIImage(data: data)
        } catch let parsingError {
            print("Error in parsing data", parsingError)
            domainIcon.image = .none
        }
        domainText.text = domain
        title.text = model.title
        author.text = "By - " + model.author.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var string = ""
        
        let date = Date(timeIntervalSince1970: TimeInterval(model.time))
        
        let calendar = Calendar.current
        
        if (calendar.component(.hour, from: date) <= 24) {
            if (calendar.component(.hour, from: date) < 10) {
                string = String(calendar.component(.hour, from: date)) + " hour ago"
            } else {
                string = String(calendar.component(.hour, from: date)) + " hours ago"
            }
        }
        
        if (calendar.component(.minute, from: date) <= 60) {
            if (calendar.component(.minute, from: date) < 10) {
                string = String(calendar.component(.minute, from: date)) + " minute ago"
            } else {
                string = String(calendar.component(.minute, from: date)) + " minutes ago"
            }
        }
        
        if (calendar.component(.second, from: date) <= 24) {
            if (calendar.component(.minute, from: date) < 10) {
                string = String(calendar.component(.minute, from: date)) + " second ago"
            } else {
                string = String(calendar.component(.minute, from: date)) + " seconds ago"
            }
        }
        
        timestamp.text = string
        upvotes.text = String(model.upVotes) + " points"
        commentsCount.text = String(model.commentCount) + " comments"
        
    }
    
}
