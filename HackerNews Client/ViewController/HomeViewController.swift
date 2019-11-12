//
//  ViewController.swift
//  HackerNews Client
//
//  Created by Divyansh  Jain on 11/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import UIKit

class HomeViewController:
UIViewController,
ViewModelDelegate,
UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate,
TopStoriesCellDelegate
{

    var list: [HNModel] = []
    var filteredList: [HNModel] = []
    var viewModel: HNViewModel?
    
    var refreshControl = UIRefreshControl()
    
    let tbv = UITableView.init(frame: CGRect.zero)
    let searchBar = UISearchBar.init(frame: CGRect.zero)
    var indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.default
        navigationItem.titleView = searchBar
        
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.dataSource = self
        view.addSubview(tbv)
        tbv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        tbv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        tbv.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        tbv.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tbv.register(TopStoriesCell.self, forCellReuseIdentifier: "topStoriesCell")
        tbv.delegate = self
        tbv.rowHeight = UITableView.automaticDimension
        tbv.estimatedRowHeight = 600
        tbv.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tbv.separatorColor = .darkGray
        tbv.separatorInset = .zero
        tbv.isHidden = true
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicatorView)
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indicatorView.startAnimating()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tbv.addSubview(refreshControl)
        
        viewModel = HNViewModel.init(delegate: self)
        viewModel?.getTopStories()
    }
    
    @objc func refresh(sender:AnyObject) {
       viewModel?.getTopStories()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        isSearching = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredList = list
        tbv.reloadData()
        isSearching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
        if let searchText = searchBar.text {
            filteredList = searchText.isEmpty ? list : list.filter {
                $0.title.contains(searchText)
            }
            tbv.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        if let searchText = searchBar.text {
             filteredList = searchText.isEmpty ? list : list.filter {
                 $0.title.contains(searchText)
             }
             tbv.reloadData()
         }
    }
    
    func getItemModel(list: [HNModel]) {
        indicatorView.stopAnimating()
        refreshControl.endRefreshing()
        let temp = list.sorted(by: { (m1, m2) -> Bool in
            m1.time > m2.time
        })
        self.list += temp
        self.filteredList += list
        
        if (!isSearching) {
            DispatchQueue.main.async {
                self.tbv.isHidden = false
                self.tbv.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentReadCount = UserDefaults.standard.value(forKey: Constants.userReadCount) as? Int
        UserDefaults.standard.set((currentReadCount ?? 0) + 1, forKey: Constants.userReadCount)
        self.navigationController?.pushViewController(StoryViewController.init(model: filteredList[indexPath.row]), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topStoriesCell", for: indexPath) as! TopStoriesCell
        cell.setData(model: filteredList[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    public func didTapBookmarkToggleFromCell(model : HNModel) {
        toggleBookmarkStory(model.id)
        model.isBookmarked = !model.isBookmarked
        tbv.reloadData()
    }
    
    private func toggleBookmarkStory(_ storyId: Int) {
        if var bookmarkedIds = UserDefaults.standard.value(forKey: Constants.bookmarkedIds) as? [Int] {
            if let itemToRemoveIndex = bookmarkedIds.firstIndex(of: storyId) {
                bookmarkedIds.remove(at: itemToRemoveIndex)
            }
            else {
                bookmarkedIds.append(storyId)
            }
            UserDefaults.standard.set(bookmarkedIds, forKey: Constants.bookmarkedIds)
        }
        else {
            UserDefaults.standard.set([storyId], forKey: Constants.bookmarkedIds)
        }
    }
    
    func shareStory(model: HNModel) {
        let items: [Any] = ["Check out this story", URL(string: model.url)!]
        let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
        present(vc, animated: true)
    }

}

