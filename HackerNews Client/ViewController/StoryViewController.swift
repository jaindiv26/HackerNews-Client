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

class StoryViewController:
UIViewController,
    ViewModelDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    WKNavigationDelegate,
    WKUIDelegate
{
    
    var list: [HNModel] = []
    var newsModel = HNModel.init()
    var viewModel: HNViewModel?
    let tbv = UITableView.init(frame: CGRect.zero)
    var tabelViewActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var webViewActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var observation: NSKeyValueObservation? = nil
    var webView = WKWebView(frame: CGRect.zero)
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
        
        navigationItem.title = newsModel.title
        
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.dataSource = self
        view.addSubview(tbv)
        tbv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        tbv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        tbv.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        tbv.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
        tbv.register(NewsCell.self, forCellReuseIdentifier: "newsCell")
        tbv.delegate = self
        tbv.rowHeight = UITableView.automaticDimension
        tbv.estimatedRowHeight = 200
        tbv.separatorStyle = UITableViewCell.SeparatorStyle.none
        tbv.separatorColor = .darkGray
        tbv.separatorInset = .zero
        
        tabelViewActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tbv.addSubview(tabelViewActivityIndicator)
        tabelViewActivityIndicator.centerYAnchor.constraint(equalTo: tbv.centerYAnchor, constant: 0).isActive = true
        tabelViewActivityIndicator.centerXAnchor.constraint(equalTo: tbv.centerXAnchor, constant: 0).isActive = true
        tabelViewActivityIndicator.hidesWhenStopped = true
        showTabelViewActivityIndicator(show: true)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        if (newsModel.commentsId.count == 0) {
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        } else {
            webView.topAnchor.constraint(equalTo: tbv.bottomAnchor, constant: 0).isActive = true
        }
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = .white
        let contestUrl = URL(string: newsModel.url)
        request = URLRequest(url: contestUrl!)
        webView.load(request)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        webViewActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(webViewActivityIndicator)
        webViewActivityIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor, constant: 0).isActive = true
        webViewActivityIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor, constant: 0).isActive = true
        webViewActivityIndicator.hidesWhenStopped = true
        showWebViewActivityIndicator(show: true)
        
        viewModel = HNViewModel.init(delegate: self)
        viewModel?.idsFetched(newsModel.commentsId, fetchedCount: 0, noOfItemsToFetch: 8)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if (Float(webView.estimatedProgress) >= 0.8) {
                showWebViewActivityIndicator(show: false)
            }
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        cell.setData(model: list[indexPath.row])
        if (indexPath.row > 0 && list[indexPath.row - 1].id == list[indexPath.row].id) {
            cell.setIndentation(leftIndentation: 20)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func getItemModel(list: [HNModel]) {
        self.list += list
        
        let temp = self.list.sorted(by: { (m1, m2) -> Bool in
            m1.id == m2.id
        })
        
        self.list.removeAll()
        self.list = temp
        
        for i in list {
            if (i.commentsId.count > 0) {
                viewModel?.idsFetched(i.commentsId, fetchedCount: 0, noOfItemsToFetch: 5)
            }
        }
        
        DispatchQueue.main.async {
            self.tbv.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            self.showTabelViewActivityIndicator(show: false)
            self.tbv.reloadData()
        }
    }
}
