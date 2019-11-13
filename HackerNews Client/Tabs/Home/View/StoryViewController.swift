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

class StoryViewController: UIViewController, UITableViewDelegate{
    
    var list: [HNModel] = []
    var newsModel = HNModel.init()
    var viewModel: StoryViewModel?
    
    private lazy var tabelView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private lazy var tabelViewActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var webViewActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var webView: WKWebView = {
        let view = WKWebView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var observation: NSKeyValueObservation? = nil
    var request = URLRequest.init(url: URL.init(fileURLWithPath: ""))
    
    init (model: HNModel) {
        super.init(nibName: nil, bundle: nil)
        self.newsModel = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createViews()
        viewModel = StoryViewModel.init(delegate: self)
        viewModel?.getData(newsModel.commentsId, currentCount: 0, pageCount: 8)
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
        self.webView.load(request)
    }
    
}

private extension StoryViewController {
    
    func createViews() {
        
        navigationItem.title = newsModel.title
        
        tabelView.dataSource = self
        view.addSubview(tabelView)
        tabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tabelView.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
        tabelView.register(NewsCell.self,
                           forCellReuseIdentifier: NewsCell.self.description())
        tabelView.delegate = self
        
        tabelView.addSubview(tabelViewActivityIndicator)
        tabelViewActivityIndicator.centerYAnchor.constraint(equalTo: tabelView.centerYAnchor).isActive = true
        tabelViewActivityIndicator.centerXAnchor.constraint(equalTo: tabelView.centerXAnchor).isActive = true
        showTabelViewActivityIndicator(show: true)
        
        view.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        if (newsModel.commentsId.count == 0) {
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        } else {
            webView.topAnchor.constraint(equalTo: tabelView.bottomAnchor, constant: 0).isActive = true
        }
        
        webView.addSubview(webViewActivityIndicator)
        webViewActivityIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor, constant: 0).isActive = true
        webViewActivityIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor, constant: 0).isActive = true
        
        showWebViewActivityIndicator(show: true)
        setUpWebView(webView)
        setUpTableView(tabelView)
    }
    
    func setUpWebView(_ webView: WKWebView) {
        let contestUrl = URL(string: newsModel.url)
        request = URLRequest(url: contestUrl!)
        webView.load(request)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func setUpTableView(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.self.description())
    }
    
    func showTabelViewActivityIndicator(show: Bool) {
        if show {
            tabelViewActivityIndicator.startAnimating()
        } else {
            tabelViewActivityIndicator.stopAnimating()
        }
    }
    
    func showWebViewActivityIndicator(show: Bool) {
        if show {
            webViewActivityIndicator.startAnimating()
        } else {
            webViewActivityIndicator.stopAnimating()
        }
    }
    
}

extension StoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.self.description(), for: indexPath) as? NewsCell {
            cell.setData(model: list[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension StoryViewController: StoryViewDelegate {
    
    func getComments(_ list: [HNModel]) {
        self.list += list
        
        let temp = self.list.sorted(by: { (m1, m2) -> Bool in
            m1.id == m2.id
        })
        
        self.list.removeAll()
        self.list = temp
        
        for i in list {
            if (i.commentsId.count > 0) {
                //viewModel?.idsFetched(i.commentsId, fetchedCount: 0, noOfItemsToFetch: 5)
            }
        }
        
        DispatchQueue.main.async {
            self.showTabelViewActivityIndicator(show: false)
            self.tabelView.reloadData()
        }
    }
}
