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
    let comment = UILabel.init(frame: CGRect.zero)
    let authorPrefix = UILabel.init(frame: CGRect.zero)
    let cellSeperator = UIView.init(frame: CGRect.zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let iconBackGroundView = UIView.init(frame: CGRect.zero)
        iconBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconBackGroundView)
        iconBackGroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        iconBackGroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        iconBackGroundView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconBackGroundView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        iconBackGroundView.backgroundColor = .systemGray5
        iconBackGroundView.layer.cornerRadius = 6
        
        authorPrefix.translatesAutoresizingMaskIntoConstraints = false
        iconBackGroundView.addSubview(authorPrefix)
        authorPrefix.centerXAnchor.constraint(equalTo: iconBackGroundView.centerXAnchor, constant: 0).isActive = true
        authorPrefix.centerYAnchor.constraint(equalTo: iconBackGroundView.centerYAnchor, constant: 0).isActive = true
        authorPrefix.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        comment.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(comment)
        comment.leadingAnchor.constraint(equalTo: iconBackGroundView.trailingAnchor, constant: UIConstants.sidePadding).isActive = true
        comment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        comment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.verticalPadding).isActive = true
        comment.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        comment.lineBreakMode = .byWordWrapping
        comment.numberOfLines = 0
        
        author.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(author)
        author.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        author.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.verticalPadding).isActive = true
        author.leadingAnchor.constraint(equalTo: comment.leadingAnchor, constant: 0).isActive = true
        author.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        author.textColor = .black
        
        timestamp.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timestamp)
        timestamp.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        timestamp.leadingAnchor.constraint(equalTo: author.trailingAnchor, constant: UIConstants.sidePadding).isActive = true
        timestamp.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.verticalPadding).isActive = true
        timestamp.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        timestamp.textColor = .darkGray
        
        cellSeperator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellSeperator)
        cellSeperator.leadingAnchor.constraint(equalTo: iconBackGroundView.leadingAnchor, constant: 0).isActive = true
        cellSeperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        cellSeperator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        cellSeperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        cellSeperator.backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(model: HNModel) {
        comment.text = model.comment
        
        author.text = "By - " + model.author.trimmingCharacters(in: .whitespacesAndNewlines)
        authorPrefix.text = String(model.author.prefix(1).uppercased())
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
    }
    
}
