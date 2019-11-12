//
//  NewsCell.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation
import UIKit

class NewsCell: UITableViewCell {
    
    let author = UILabel.init(frame: CGRect.zero)
    let timestamp = UILabel.init(frame: CGRect.zero)
    let id = UILabel.init(frame: CGRect.zero)
    let comment = UILabel.init(frame: CGRect.zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        author.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(author)
        author.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        author.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        author.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        author.textColor = .black
        
        timestamp.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timestamp)
        timestamp.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        timestamp.leadingAnchor.constraint(equalTo: author.trailingAnchor, constant: 12).isActive = true
        timestamp.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        timestamp.textColor = .darkGray
        
        id.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(id)
        id.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        id.leadingAnchor.constraint(equalTo: timestamp.trailingAnchor, constant: 12).isActive = true
        id.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        id.textColor = .darkGray

        comment.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(comment)
        comment.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 12).isActive = true
        comment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        comment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        comment.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        comment.lineBreakMode = .byWordWrapping
        comment.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(model: HNModel) {
        comment.text = model.comment
        
        author.text = "By - " + model.author.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var string = ""
        
        let date = Date(timeIntervalSince1970: TimeInterval(model.time))
        
        let calendar = Calendar.current
        
        if (calendar.component(.hour, from: date) <= 24) {
            if (calendar.component(.hour, from: date) < 10) {
                string = String(calendar.component(.hour, from: date)) + "hour ago"
            } else {
                string = String(calendar.component(.hour, from: date)) + "hours ago"
            }
        }
        
        if (calendar.component(.minute, from: date) <= 60) {
            if (calendar.component(.minute, from: date) < 10) {
                string = String(calendar.component(.minute, from: date)) + "minute ago"
            } else {
                string = String(calendar.component(.minute, from: date)) + "minutes ago"
            }
        }
        
        if (calendar.component(.second, from: date) <= 24) {
            if (calendar.component(.minute, from: date) < 10) {
                string = String(calendar.component(.minute, from: date)) + "second ago"
            } else {
                string = String(calendar.component(.minute, from: date)) + "seconds ago"
            }
        }
        
        timestamp.text = string
        id.text = String(model.id)
    }
    
    public func setIndentation(leftIndentation: CGFloat) {
        author.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftIndentation).isActive = true
        timestamp.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftIndentation).isActive = true
        comment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftIndentation).isActive = true
        author.layoutIfNeeded()
        timestamp.layoutIfNeeded()
        comment.layoutIfNeeded()
    }
    
}