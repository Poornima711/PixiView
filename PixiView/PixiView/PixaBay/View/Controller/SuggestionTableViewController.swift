//
//  SuggestionTableViewController.swift
//  PixiView
//
//  Created by tcs on 17/01/21.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource {
    
    func setUpTableView() {
        suggestionTableView.isHidden = true
        suggestionTableView.dataSource = self
        suggestionTableView.delegate = self
        suggestionTableView.backgroundColor = .white
        tableHeight.constant = suggestionTableView.contentSize.height/2
    }
    
    func hideTable() {
        self.view.subviews.forEach { (view) in
            if view.isKind(of: UITableView.self) {
                view.isHidden = true
            }
        }
    }
    
    func updateQueryArray() {
        
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

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchQueryArray = DataManager.readDataFromUserDefaults(key: "queryArray") as? [String] else { return }
        searchText = searchQueryArray[indexPath.row]
        page = 1
        callSearchApi()
        helpLabel.isHidden = true
        searchBar.text = ""
        hideTable()
    }
    
}
