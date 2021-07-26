//
//  CommunityListViewController.swift
//  Resume
//
//  Created by Manu Gupta on 06/11/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
protocol CommunityListViewControllerDelegate: NSObjectProtocol {
    func returnSelectedCommunity(selectedCommunity: SelectedCommunity)
}

class CommunityListViewController: CustomizedViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    
    var communityList = [CommunityList]()
    var filteredcommunityList = [CommunityList]()
    var selectedCommunity : SelectedCommunity?
    weak var delegate : CommunityListViewControllerDelegate?
    var refreshControl = UIRefreshControl()
    
    // Search
    let searchController = UISearchController(searchResultsController: nil)
    var apiRunnig = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizationTable()
        communityList = CommunityListService().getCommunityListFromDB()
        searchController.searchBar.delegate = self
        searchController.isActive = true
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.placeholder = "Search school"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
            searchController.searchBar.barStyle = .default
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchButtonTapped(_:)))
        }
        definesPresentationContext = true
        // Setup the search footer
//        tableView.tableFooterView = searchFooter
        searchController.hidesNavigationBarDuringPresentation = true
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        searchFooter.removeFromSuperview()
        searchController.searchBar.inputAccessoryView = searchFooter
        setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for (index,community) in communityList.enumerated(){
            if community.displayName == selectedCommunity?.displayName {
                tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
                break
            }
        }
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: School List")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorCode.textColor, NSAttributedString.Key.font: UIFont(name: "SanFranciscoText-Regular", size: 18)!]
    }
    
    func setupPullToRefresh(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(self.refreshTable), for: UIControl.Event.valueChanged)
        self.tableView?.addSubview(refreshControl)
    }
    
    @objc func refreshTable(){
        getCommunityListFromServer()
    }
    
    func getCommunityListFromServer(){
        if apiRunnig{
            self.stopRefreshing()
            return
        }
        apiRunnig = true
        CommunityListService().getCommunityListCall({ response in
            
            self.apiRunnig = false
            
            self.communityList = CommunityListService().getCommunityListFromDB()
            self.stopRefreshing()
            NSLog("reloadData")
            self.tableView.reloadData()
        }, failure: { (error,errorCode) in
            self.stopRefreshing()
        })
    }
    
    func stopRefreshing(){
        if self.refreshControl.isRefreshing{
            self.refreshControl.endRefreshing()
        }
    }
    
    func customizationTable(){
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        communityList = []
    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem){
        searchController.searchBar.becomeFirstResponder()
    }
    
    // MARK: - Private instance methods
    func filterContentForSearchText(_ searchText: String) {
        filteredcommunityList = communityList.filter({( community : CommunityList) -> Bool in
            return (community.displayName?.lowercased().contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)))!
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    @IBAction func backButtonTapped(_ sender : UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
}

extension CommunityListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredcommunityList.count, of: communityList.count)
            return filteredcommunityList.count
        }
        searchFooter.setNotFiltering()
        return communityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityListTableViewCell") as! CommunityListTableViewCell
        cell.optionTextlabel.text = isFiltering() ? filteredcommunityList[indexPath.row].displayName : communityList[indexPath.row].displayName
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.returnSelectedCommunity(selectedCommunity: SelectedCommunity(id: isFiltering() ? filteredcommunityList[indexPath.row].id : communityList[indexPath.row].id ,
                                                                               displayName: isFiltering() ? filteredcommunityList[indexPath.row].displayName! : communityList[indexPath.row].displayName!,
                                                                               tagName: isFiltering() ? filteredcommunityList[indexPath.row].tagName! : communityList[indexPath.row].tagName!))
        self.navigationController?.popViewController(animated: true)
    }
}

extension CommunityListViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

extension CommunityListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
