//
//  TopStoriesCell.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

protocol TopStoriesCellDelegate {
    func didTapBookmarkToggleFromCell(model: HNModel)
    func shareStory(model: HNModel)
}

class TopStoriesCell: UITableViewCell {
    
    let domainIcon = UIImageView.init(frame: CGRect.zero)
    let domainText = UILabel.init(frame: CGRect.zero)
    let title = UILabel.init(frame: CGRect.zero)
    let author = UILabel.init(frame: CGRect.zero)
    let timestamp = UILabel.init(frame: CGRect.zero)
    let upvotes = UILabel.init(frame: CGRect.zero)
    let commentsCount = UILabel.init(frame: CGRect.zero)
    let shareButton = UIButton(type: .system)
    let bookmarkButton = UIButton(type: .system)
    
    var model: HNModel?
    var delegate: TopStoriesCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        domainIcon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(domainIcon)
        domainIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        domainIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        domainIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        domainIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        domainIcon.contentMode = .scaleAspectFit
        
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        title.leadingAnchor.constraint(equalTo: domainIcon.trailingAnchor, constant: 12).isActive = true
        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        
        domainText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(domainText)
        domainText.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12).isActive = true
        domainText.leadingAnchor.constraint(equalTo: domainIcon.trailingAnchor, constant: 12).isActive = true
        domainText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        domainText.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        domainText.textColor = .darkGray
        
        author.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(author)
        author.leadingAnchor.constraint(equalTo: domainIcon.trailingAnchor, constant: 12).isActive = true
        author.topAnchor.constraint(equalTo: domainText.bottomAnchor, constant: 12).isActive = true
        author.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        author.textColor = .black
        
        timestamp.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timestamp)
        timestamp.leadingAnchor.constraint(equalTo: author.trailingAnchor, constant: 12).isActive = true
        timestamp.topAnchor.constraint(equalTo: domainText.bottomAnchor, constant: 12).isActive = true
        timestamp.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        timestamp.textColor = .darkGray
        
        upvotes.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(upvotes)
        upvotes.leadingAnchor.constraint(equalTo: domainIcon.trailingAnchor, constant: 12).isActive = true
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
        
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shareButton)
        shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.addTarget(self, action:#selector(shareStory), for: UIControl.Event.touchUpInside)
        
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bookmarkButton)
        bookmarkButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -12).isActive = true
        bookmarkButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        bookmarkButton.setImage(UIImage(named: "bookmark_16px"), for: .normal)
        bookmarkButton.addTarget(self, action:#selector(didTapBookmarkButton), for: UIControl.Event.touchUpInside)
    }
    
    @objc func shareStory() {
        guard let model = model else {
            return
        }
        delegate?.shareStory(model: model)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapBookmarkButton() {
        guard let model = model else {
            return
        }
        delegate?.didTapBookmarkToggleFromCell(model: model)
    }
    
    public func setData(model: HNModel) {
        self.model = model
        guard let domain = URL(string: model.url)?.host else {
            return
        }

        guard let url = URL(string: Constants.domainIconEndpoint + domain) else {
            return
        }
        
        domainIcon.downloaded(from: url)

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
        
        if (model.isBookmarked) {
            bookmarkButton.tintColor = .orange
        } else {
            bookmarkButton.tintColor = .none
        }
    }
    
}
