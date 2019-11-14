//
//  CommentsCell.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation
import UIKit

class CommentsCell: UITableViewCell {
    
    private lazy var iconBackGroundView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = UIConstants.cornerRadius
        return view
    }()
    
    private lazy var author: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
        authorPrefix.text = String(model.author.prefix(1).uppercased())
        comment.text = model.comment
        
        author.text = "By - " + model.author.trimmingCharacters(in: .whitespacesAndNewlines)
        timestamp.text = " • " + setTimestamp(epochTime: String(model.time))
    }
    
}

func getMonthNameFromInt(month: Int) -> String {
    switch month {
    case 1:
        return "Jan"
    case 2:
        return "Feb"
    case 3:
        return "Mar"
    case 4:
        return "Apr"
    case 5:
        return "May"
    case 6:
        return "Jun"
    case 7:
        return "Jul"
    case 8:
        return "Aug"
    case 9:
        return "Sept"
    case 10:
        return "Oct"
    case 11:
        return "Nov"
    case 12:
        return "Dec"
    default:
        return ""
    }
}

func setTimestamp(epochTime: String) -> String {
    let currentDate = Date()
    let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime) as! TimeInterval)
    
    let calendar = Calendar.current
    
    let currentDay = calendar.component(.day, from: currentDate)
    let currentHour = calendar.component(.hour, from: currentDate)
    let currentMinutes = calendar.component(.minute, from: currentDate)
    let currentSeconds = calendar.component(.second, from: currentDate)
    
    let epochDay = calendar.component(.day, from: epochDate)
    let epochMonth = calendar.component(.month, from: epochDate)
    let epochYear = calendar.component(.year, from: epochDate)
    let epochHour = calendar.component(.hour, from: epochDate)
    let epochMinutes = calendar.component(.minute, from: epochDate)
    let epochSeconds = calendar.component(.second, from: epochDate)
    
    if (currentDay - epochDay < 30) {
        if (currentDay == epochDay) {
            if (currentHour - epochHour == 0) {
                if (currentMinutes - epochMinutes == 0) {
                    if (currentSeconds - epochSeconds <= 1) {
                        return String(currentSeconds - epochSeconds) + " second ago"
                    } else {
                        return String(currentSeconds - epochSeconds) + " seconds ago"
                    }
                    
                } else if (currentMinutes - epochMinutes <= 1) {
                    return String(currentMinutes - epochMinutes) + " minute ago"
                } else {
                    return String(currentMinutes - epochMinutes) + " minutes ago"
                }
            } else if (currentHour - epochHour <= 1) {
                return String(currentHour - epochHour) + " hour ago"
            } else {
                return String(currentHour - epochHour) + " hours ago"
            }
        } else if (currentDay - epochDay <= 1) {
            return String(currentDay - epochDay) + " day ago"
        } else {
            return String(currentDay - epochDay) + " days ago"
        }
    } else {
        return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
    }
}

private extension CommentsCell {
    
    func createViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(iconBackGroundView)
        iconBackGroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: UIConstants.sidePadding).isActive = true
        iconBackGroundView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: UIConstants.verticalPadding).isActive = true
        iconBackGroundView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconBackGroundView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        iconBackGroundView.addSubview(authorPrefix)
        authorPrefix.centerXAnchor.constraint(equalTo: iconBackGroundView.centerXAnchor).isActive = true
        authorPrefix.centerYAnchor.constraint(equalTo: iconBackGroundView.centerYAnchor).isActive = true
        
        contentView.addSubview(comment)
        comment.leadingAnchor.constraint(equalTo: iconBackGroundView.trailingAnchor,
                                         constant: UIConstants.sidePadding).isActive = true
        comment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                          constant: -UIConstants.sidePadding).isActive = true
        comment.topAnchor.constraint(equalTo: iconBackGroundView.topAnchor).isActive = true
        
        contentView.addSubview(author)
        author.topAnchor.constraint(equalTo: comment.bottomAnchor,
                                    constant: UIConstants.verticalPadding).isActive = true
        author.leadingAnchor.constraint(equalTo: comment.leadingAnchor).isActive = true
        
        contentView.addSubview(timestamp)
        timestamp.leadingAnchor.constraint(equalTo: author.trailingAnchor).isActive = true
        timestamp.centerYAnchor.constraint(equalTo: author.centerYAnchor).isActive = true
        
        contentView.addSubview(cellSeperator)
        cellSeperator.topAnchor.constraint(equalTo: author.bottomAnchor,
                                           constant: UIConstants.verticalPadding).isActive = true
        cellSeperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: UIConstants.sidePadding).isActive = true
        cellSeperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -UIConstants.sidePadding).isActive = true
        cellSeperator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellSeperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
