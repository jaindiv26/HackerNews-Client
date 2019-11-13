//
//  StoryViewController.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class StoryViewController: BaseViewController {
    
    private lazy var commentsMainView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var commentsLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Comments"
        return label
    }()
    
    private lazy var commentsSubView: UIView = {
       let view = UIView.init()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.backgroundColor = .systemGray4
       view.layer.cornerRadius = UIConstants.cornerRadius
       view.layer.borderWidth = 0.5
       view.layer.borderColor = UIColor.systemGray2.cgColor
       view.clipsToBounds = true
       return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private lazy var tableViewActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var moreDetailsMainView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var moreDetailsLabel: UILabel = {
       let label = UILabel.init(frame: CGRect.zero)
       label.translatesAutoresizingMaskIntoConstraints = false
       label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
       label.text = "More Details"
       return label
    }()
   
    private lazy var moreDetailsSubView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = UIConstants.cornerRadius
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var webView: WKWebView = {
       let view = WKWebView(frame: CGRect.zero)
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    private lazy var webViewActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let newsModel: HNModel
    private var viewModel: StoryViewModel?
    private var observation: NSKeyValueObservation?
    private var webviewUrlRequest: URLRequest?
    
    init(model: HNModel) {
        self.newsModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        createViews()
        showTableViewActivityIndicator(show: true)
        viewModel = StoryViewModel.init(commentIds: newsModel.commentsId,
                                        delegate: self)
        viewModel?.getData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if (Float(webView.estimatedProgress) >= 0.8) {
                showWebViewActivityIndicator(show: false)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showWebViewActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showWebViewActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showWebViewActivityIndicator(show: false)
        if let webviewUrlRequest = webviewUrlRequest {
            webView.load(webviewUrlRequest)
        }
    }
    
}

private extension StoryViewController {
    
    func createViews() {
        navigationItem.title = newsModel.title
        if newsModel.commentsId.isEmpty {
            showWebView()
        }
        else {
            showCommentsAndWebview()
            setUpTableView(tableView)
        }
        showWebViewActivityIndicator(show: true)
        setUpWebView(webView)
    }
    
    func showCommentsAndWebview() {

        view.addSubview(commentsMainView)
        commentsMainView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: UIConstants.sidePadding).isActive = true
        commentsMainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                              constant: UIConstants.verticalPadding).isActive = true
        commentsMainView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -UIConstants.sidePadding).isActive = true
        
        commentsMainView.addSubview(commentsLabel)
        commentsLabel.leadingAnchor.constraint(equalTo: commentsMainView.leadingAnchor).isActive = true
        commentsLabel.topAnchor.constraint(equalTo: commentsMainView.topAnchor).isActive = true
        commentsLabel.trailingAnchor.constraint(equalTo: commentsMainView.trailingAnchor,
                                                constant: -UIConstants.sidePadding).isActive = true
        
        commentsMainView.addSubview(commentsSubView)
        commentsSubView.leadingAnchor.constraint(equalTo: commentsMainView.leadingAnchor).isActive = true
        commentsSubView.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: UIConstants.verticalPadding).isActive = true
        commentsSubView.trailingAnchor.constraint(equalTo: commentsMainView.trailingAnchor).isActive = true
        commentsSubView.bottomAnchor.constraint(equalTo: commentsMainView.bottomAnchor).isActive = true
        
        commentsSubView.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: commentsSubView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: commentsSubView.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: commentsSubView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: commentsSubView.bottomAnchor).isActive = true
        
        tableView.addSubview(tableViewActivityIndicator)
        tableViewActivityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        tableViewActivityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        
        //More Details View
        
        view.addSubview(moreDetailsMainView)
        moreDetailsMainView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: UIConstants.sidePadding).isActive = true
        moreDetailsMainView.topAnchor.constraint(equalTo: commentsMainView.bottomAnchor,
                                                 constant: UIConstants.verticalPadding).isActive = true
        moreDetailsMainView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: -UIConstants.sidePadding).isActive = true
        moreDetailsMainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -UIConstants.verticalPadding).isActive = true
        
        moreDetailsMainView.addSubview(moreDetailsLabel)
        moreDetailsLabel.leadingAnchor.constraint(equalTo: moreDetailsMainView.leadingAnchor).isActive = true
        moreDetailsLabel.topAnchor.constraint(equalTo: moreDetailsMainView.topAnchor).isActive = true
        moreDetailsLabel.trailingAnchor.constraint(equalTo: moreDetailsMainView.trailingAnchor).isActive = true
        
        moreDetailsMainView.addSubview(moreDetailsSubView)
        moreDetailsSubView.leadingAnchor.constraint(equalTo: moreDetailsMainView.leadingAnchor).isActive = true
        moreDetailsSubView.topAnchor.constraint(equalTo: moreDetailsLabel.bottomAnchor,
                                                constant: UIConstants.verticalPadding).isActive = true
        moreDetailsSubView.trailingAnchor.constraint(equalTo: moreDetailsMainView.trailingAnchor).isActive = true
        moreDetailsSubView.bottomAnchor.constraint(equalTo: moreDetailsMainView.bottomAnchor).isActive = true
        
        moreDetailsSubView.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: moreDetailsSubView.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: moreDetailsSubView.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: moreDetailsSubView.bottomAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: moreDetailsSubView.topAnchor).isActive = true
        
        webView.addSubview(webViewActivityIndicator)
        webViewActivityIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        webViewActivityIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        
        commentsMainView.heightAnchor.constraint(equalTo: moreDetailsMainView.heightAnchor,
                                                 multiplier: 1).isActive = true
    }
    
    func showWebView() {
        view.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        webView.addSubview(webViewActivityIndicator)
        webViewActivityIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        webViewActivityIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
    }
    
    func setUpWebView(_ webView: WKWebView) {
        guard let commentsUrl = URL(string: newsModel.url) else {
            return
        }
        webviewUrlRequest = URLRequest(url: commentsUrl)
        if let webviewUrlRequest = webviewUrlRequest {
            webView.load(webviewUrlRequest)
        }
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }
    
    func setUpTableView(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.register(CommentsCell.self, forCellReuseIdentifier: CommentsCell.self.description())
    }
    
    func showTableViewActivityIndicator(show: Bool) {
        if show {
            tableViewActivityIndicator.startAnimating()
        }
        else {
            tableViewActivityIndicator.stopAnimating()
        }
    }
    
    func showWebViewActivityIndicator(show: Bool) {
        if show {
            webViewActivityIndicator.startAnimating()
        }
        else {
            webViewActivityIndicator.stopAnimating()
        }
    }
    
}

extension StoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getTotalItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if let item = viewModel?.getItem(forRow: indexPath.row),
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCell.self.description(), for: indexPath) as? CommentsCell {
            cell.setData(model: item)
            return cell
        }
        return UITableViewCell()
    }
}

extension StoryViewController: StoryBaseViewModelDelegate {
    
    func reloadData() {
        showTableViewActivityIndicator(show: false)
        tableView.reloadData()
    }
    
    func storyBaseViewModel(_ storyBaseViewModel: StoryBaseViewModel,
                            didFailToFetchResultsWithError error: Error?) {
        showTableViewActivityIndicator(show: false)
        showWebViewActivityIndicator(show: false)
        showErrorMessage(error?.localizedDescription)
    }
    
    
}
