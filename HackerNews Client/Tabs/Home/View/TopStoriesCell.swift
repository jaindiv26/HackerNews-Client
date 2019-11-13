//
//  TopStoriesCell.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation
import UIKit

protocol TopStoriesCellDelegate: class {
    
    func topStoriesCell(_ topStoriesCell:TopStoriesCell,
                        didTapBookmarkButtonForData data: HNModel)
    
    func topStoriesCell(_ topStoriesCell:TopStoriesCell,
                        didTapShareButtonForData data: HNModel)
}

class TopStoriesCell: UITableViewCell {
    
    private lazy var iconBackGroundView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = UIConstants.cornerRadius
        return view
    }()
    
    private lazy var domainImageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var domainText: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var author: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var timestamp: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var upvotes: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var commentsCount: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: UIConstants.Image.shareOutline.rawValue), for: .normal)
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .orange
        button.setImage(UIImage(named: UIConstants.Image.bookmarkOutline.rawValue), for: .normal)
        return button
    }()
    
    let cellSeperator = UIView.init(frame: CGRect.zero)
    
    var model: HNModel?
    weak var delegate: TopStoriesCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    public func setData(model: HNModel) {
        self.model = model

        if let url = URL(string: Constants.domainIconEndpoint + model.url) {
            domainImageView.downloaded(from: url)
        }
        else {
            imageView?.image = nil
        }
        
        title.text = model.title
        domainText.text = model.url
        author.text = "By - \(model.author.trimmingCharacters(in: .whitespacesAndNewlines))"
        
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
        
        timestamp.text = " • \(string)"
        upvotes.text = "\(model.upVotes) points"
        commentsCount.text = " • \(model.commentCount) comments"
        
        if model.isBookmarked {
            bookmarkButton.setImage(UIImage(named: UIConstants.Image.bookmarkFilled.rawValue), for: .normal)
        }
        else {
            bookmarkButton.setImage(UIImage(named: UIConstants.Image.bookmarkOutline.rawValue), for: .normal)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        domainImageView.image = nil
        title.text = nil
        domainText.text = nil
        author.text = nil
        timestamp.text = nil
        upvotes.text = nil
        commentsCount.text = nil
    }
    
}

private extension TopStoriesCell {
    
    func createViews() {
        contentView.addSubview(iconBackGroundView)
        iconBackGroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: UIConstants.sidePadding).isActive = true
        iconBackGroundView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: UIConstants.verticalPadding).isActive = true
        iconBackGroundView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconBackGroundView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    
        iconBackGroundView.addSubview(domainImageView)
        domainImageView.centerXAnchor.constraint(equalTo: iconBackGroundView.centerXAnchor,
                                                 constant: 0).isActive = true
        domainImageView.centerYAnchor.constraint(equalTo: iconBackGroundView.centerYAnchor,
                                                 constant: 0).isActive = true
        domainImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        domainImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        contentView.addSubview(title)
        title.topAnchor.constraint(equalTo: iconBackGroundView.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: iconBackGroundView.trailingAnchor,
                                       constant: UIConstants.sidePadding).isActive = true
        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                        constant: -UIConstants.sidePadding).isActive = true
        
        domainText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(domainText)
        domainText.topAnchor.constraint(equalTo: title.bottomAnchor,
                                        constant: UIConstants.betweenPadding).isActive = true
        domainText.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
        domainText.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
        
        author.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(author)
        author.topAnchor.constraint(equalTo: domainText.bottomAnchor,
                                    constant: UIConstants.betweenPadding).isActive = true
        author.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
        
        timestamp.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timestamp)
        timestamp.leadingAnchor.constraint(equalTo: author.trailingAnchor).isActive = true
        timestamp.centerYAnchor.constraint(equalTo: author.centerYAnchor).isActive = true
        
        upvotes.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(upvotes)
        upvotes.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
        upvotes.topAnchor.constraint(equalTo: author.bottomAnchor,
                                     constant: UIConstants.betweenPadding).isActive = true
        
        commentsCount.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(commentsCount)
        commentsCount.leadingAnchor.constraint(equalTo: upvotes.trailingAnchor).isActive = true
        commentsCount.centerYAnchor.constraint(equalTo: upvotes.centerYAnchor).isActive = true
        
        cellSeperator.backgroundColor = .systemGray2
        cellSeperator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellSeperator)
        cellSeperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: UIConstants.sidePadding).isActive = true
        cellSeperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -UIConstants.sidePadding).isActive = true
        cellSeperator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellSeperator.topAnchor.constraint(equalTo: upvotes.bottomAnchor,
                                           constant: UIConstants.verticalPadding).isActive = true
        cellSeperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        shareButton.addTarget(self,
                              action:#selector(didTapShareButton),
                              for: UIControl.Event.touchUpInside)
        contentView.addSubview(shareButton)
        shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                              constant: -UIConstants.sidePadding).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: commentsCount.bottomAnchor).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: UIConstants.iconSize.width).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: UIConstants.iconSize.height).isActive = true
        
        bookmarkButton.addTarget(self,
                                 action:#selector(didTapBookmarkButton),
                                 for: UIControl.Event.touchUpInside)
        contentView.addSubview(bookmarkButton)
        bookmarkButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor,
                                                 constant: -UIConstants.sidePadding).isActive = true
        bookmarkButton.bottomAnchor.constraint(equalTo: commentsCount.bottomAnchor).isActive = true
        bookmarkButton.heightAnchor.constraint(equalToConstant: UIConstants.iconSize.width).isActive = true
        bookmarkButton.widthAnchor.constraint(equalToConstant: UIConstants.iconSize.height).isActive = true
    }
    
    @objc func didTapShareButton() {
        guard let model = model else {
            return
        }
        delegate?.topStoriesCell(self, didTapShareButtonForData: model)
    }
    
    @objc func didTapBookmarkButton() {
        guard let model = model else {
            return
        }
        delegate?.topStoriesCell(self, didTapBookmarkButtonForData: model)
    }
    
}
