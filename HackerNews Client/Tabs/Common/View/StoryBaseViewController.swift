//
//  StoryBaseViewController.swift
//  HackerNews Client
//
//  Created by Divyansh Jain on 13/11/19.
//  Copyright © 2019 Divyansh  Jain. All rights reserved.
//

import UIKit

class StoryBaseViewController: BaseViewController {

    private lazy var refreshControl = UIRefreshControl()
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    public lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar.init()
        return searchBar
    }()
    
    private lazy var indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    public lazy var viewModel: StoryBaseViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        createViews()
        viewModel = getViewModel()
        viewModel?.getData()
    }
    
    override public func didTapRetryButton(_ errorView: ErrorView) {
        errorView.isHidden = true
        indicatorView.startAnimating()
        viewModel?.getData()
    }
    
    func topStoriesCell(_ topStoriesCell: TopStoriesCell,
                        didTapBookmarkButtonForData data: HNModel) {
           
    }
    
    func getViewModel() -> StoryBaseViewModel? {
        return nil
    }
    
    func reloadData() {
        searchBar.isUserInteractionEnabled = true
        indicatorView.stopAnimating()
        refreshControl.endRefreshing()
        tableView.isHidden = false
        tableView.reloadData()
    }
}

private extension StoryBaseViewController {
    
    func createViews() {
        searchBar.delegate = self
        searchBar.isUserInteractionEnabled = false
        navigationItem.titleView = searchBar
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor,
                                       constant: UIConstants.verticalPadding).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicatorView)
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.startAnimating()
        
        refreshControl.addTarget(self,
                                 action: #selector(didPullToRefresh),
                                 for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        setUpTableView(tableView)
    }
    
    func setUpTableView(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TopStoriesCell.self,
                           forCellReuseIdentifier: TopStoriesCell.self.description())
    }
    
    @objc func didPullToRefresh(sender: AnyObject) {
       viewModel?.doRefresh()
    }
    
}

extension StoryBaseViewController: StoryBaseViewModelDelegate {
    
    func storyBaseViewModel(_ storyBaseViewModel: StoryBaseViewModel,
                            didFailToFetchResultsWithError error: Error?) {
        indicatorView.stopAnimating()
        refreshControl.endRefreshing()
        tableView.reloadData()
        if viewModel?.getTotalItems() ?? 0 == 0 {
            searchBar.isUserInteractionEnabled = false
            showErrorView(error?.localizedDescription)
        }
        else {
            searchBar.isUserInteractionEnabled = true
            showErrorMessage(error?.localizedDescription)
        }
    }
    
}

extension StoryBaseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getTotalItems() ?? 0
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = viewModel?.getItem(forRow: indexPath.row),
            let cell = tableView.dequeueReusableCell(withIdentifier: TopStoriesCell.self.description(),
                                                    for: indexPath) as? TopStoriesCell {
            cell.setData(item)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
      
}

extension StoryBaseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel?.getItem(forRow: indexPath.row) else {
            return
        }
        viewModel?.didClickItem()
        navigationController?.pushViewController(StoryViewController.init(model: item), animated: true)
    }
    
}

extension StoryBaseViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        viewModel?.doSearch(forQuery: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.doSearch(forQuery: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.doSearch(forQuery: searchBar.text)
    }
    
}

extension StoryBaseViewController: TopStoriesCellDelegate {
    
    func topStoriesCell(_ topStoriesCell:TopStoriesCell,
                           didTapShareButtonForData data: HNModel){
       guard let url = URL(string: data.url) else {
           return
       }
       let items: [Any] = [Constants.sharingMessage, url]
       let sharingVC = UIActivityViewController(activityItems: items, applicationActivities: [])
       present(sharingVC, animated: true)
    }
    
}
