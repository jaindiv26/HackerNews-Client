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
    
    private lazy var iconBackGroundView: UIView = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 6
        return view
    }()
    
    private lazy var author: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var timestamp: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var comment: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorPrefix: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var cellSeperator: UIView = {
        let view = UILabel.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        author.text = nil
        timestamp.text = nil
        comment.text = nil
        authorPrefix.text = nil
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

private extension NewsCell {
    
    func createViews() {
        
        contentView.addSubview(iconBackGroundView)
        iconBackGroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        iconBackGroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        iconBackGroundView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconBackGroundView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        iconBackGroundView.addSubview(authorPrefix)
        authorPrefix.centerXAnchor.constraint(equalTo: iconBackGroundView.centerXAnchor, constant: 0).isActive = true
        authorPrefix.centerYAnchor.constraint(equalTo: iconBackGroundView.centerYAnchor, constant: 0).isActive = true
        
        contentView.addSubview(comment)
        comment.leadingAnchor.constraint(equalTo: iconBackGroundView.trailingAnchor, constant: UIConstants.sidePadding).isActive = true
        comment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.sidePadding).isActive = true
        comment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.verticalPadding).isActive = true
        
        contentView.addSubview(author)
        author.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        author.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.verticalPadding).isActive = true
        author.leadingAnchor.constraint(equalTo: comment.leadingAnchor, constant: 0).isActive = true
        
        contentView.addSubview(timestamp)
        timestamp.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        timestamp.leadingAnchor.constraint(equalTo: author.trailingAnchor, constant: UIConstants.sidePadding).isActive = true
        timestamp.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.verticalPadding).isActive = true
        
        contentView.addSubview(cellSeperator)
        cellSeperator.leadingAnchor.constraint(equalTo: iconBackGroundView.leadingAnchor, constant: 0).isActive = true
        cellSeperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        cellSeperator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
}
