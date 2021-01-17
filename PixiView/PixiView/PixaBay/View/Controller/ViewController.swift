//
//  ViewController.swift
//  PixiView
//
//  Created by tcs on 15/01/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var presenter: PhotoDataPresenter?
    var responseObject: PhotoResponse?
    var pageViewController: UIPageViewController?
    var totalImages: Int?
    var page = 1
    var searchText: String = ""
    static var searchQueryArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "PixiView"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.presenter = PhotoDataPresenter(controller: self)
        suggestionTableView.register(UINib(nibName: "QueryTableViewCell", bundle: nil), forCellReuseIdentifier: "QueryTableViewCell")
        helpLabel.isHidden = false
        setUpCollectionView()
        setUpSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hideTable()
    }
    
    func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func setUpCollectionView() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
    
    func callSearchApi() {
        presenter?.getSearchResult(searchKey: searchText, pageNumber: page) { (success)  in
            if success {
                self.responseObject = self.presenter?.getResponseObject()
                self.totalImages = self.responseObject?.totalHits
                self.fillSearchArray()
                self.photoCollectionView.reloadData()
            } else {
                if self.page == 1 { // show error only when page = 1 (becoz in first page itself we couldnot find the data), else dont show error
                    self.showAlertOnNoResults()
                }
            }
        }
    }
    
    func showAlertOnNoResults() {
        let alert = UIAlertController(title: "Oops!", message: "We could not find what you are looking for, try searching something else.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func fillSearchArray() {
        if var queryArray = DataManager.readDataFromUserDefaults(key: "queryArray") as? [String] {
            if !queryArray.contains(searchText) {
                queryArray.append(searchText)
            }
            ViewController.searchQueryArray = queryArray
        }
        DataManager.writeDataToUserDefaults(data: ViewController.searchQueryArray as AnyObject, key: "queryArray")
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.searchTextField.text else { return }
        self.helpLabel.isHidden = true
        self.suggestionTableView.isHidden = true
        searchText = query
        page = 1
        callSearchApi()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty ?? false {
            helpLabel.isHidden = false
            responseObject = nil
            self.suggestionTableView.isHidden = true
            photoCollectionView.reloadData()
        } else {
            self.suggestionTableView.isHidden = false
            suggestionTableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.suggestionTableView.isHidden = false
        //suggestionTableView.reloadData()
        setUpTableView()
    }
}
