//
//  SuggestionTableViewController.swift
//  PixiView
//
//  Created by tcs on 17/01/21.
//

import Foundation
import UIKit

extension PhotoViewController: UITableViewDataSource {
    
    func setUpTableView() {
        suggestionTableView.isHidden = true
        suggestionTableView.dataSource = self
        suggestionTableView.delegate = self
        suggestionTableView.backgroundColor = .white
        suggestionTableView.separatorStyle = .none
        tableHeight.constant = suggestionTableView.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchQueryArray = DataManager.readDataFromUserDefaults(key: "queryArray") else { return 0 }
        return searchQueryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QueryTableViewCell", for: indexPath) as? QueryTableViewCell else { return UITableViewCell() }
        guard let searchQueryArray = DataManager.readDataFromUserDefaults(key: "queryArray") as? [String] else { return UITableViewCell() }
        cell.queryString.text = searchQueryArray[indexPath.row]
        return cell
    }
}

extension PhotoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchQueryArray = DataManager.readDataFromUserDefaults(key: "queryArray") as? [String] else { return }
        searchText = searchQueryArray[indexPath.row]
        presenter?.clearPhotoDataArray()
        page = 1
        callSearchApi(pagination: false)
        helpLabel.isHidden = true
        suggestionTableView.isHidden = true
        searchBar.text = searchText
    }
    
}
