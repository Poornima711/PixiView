//
//  ViewController.swift
//  PixiView
//
//  Created by tcs on 15/01/21.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: PhotoDataPresenter?
    var responseObject: PhotoResponse?
    var photoDataObject: [PhotoData]?
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
        suggestionTableView.isHidden = true
    }
    
    func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func setUpCollectionView() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
    
    func callSearchApi(pagination: Bool) {
        self.activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        presenter?.getSearchResult(searchKey: searchText, pageNumber: page, pagination: pagination) { [weak self] (success)  in
            if success {
                self?.responseObject = self?.presenter?.getResponseObject()
                self?.photoDataObject = self?.presenter?.getPhotoDataObject()
                self?.totalImages = self?.responseObject?.totalHits
                self?.fillSearchArray()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                self?.photoCollectionView.reloadData()
            } else {
                if self?.page == 1 { // show error only when page = 1 (becoz in first page itself we couldnot find the data), else dont show error
                    self?.showAlertOnNoResults()
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
            PhotoViewController.searchQueryArray = queryArray
        }
        DataManager.writeDataToUserDefaults(data: PhotoViewController.searchQueryArray as AnyObject, key: "queryArray")
        updateQueryArray()
    }
    
    func updateQueryArray() {
        if var queryArray = DataManager.readDataFromUserDefaults(key: "queryArray") as? [String] {
            if  queryArray.count > 10 {
                for index in 0...queryArray.count - 10 {
                    queryArray.remove(at: index)
                }
                PhotoViewController.searchQueryArray = queryArray
            }
        }
        DataManager.writeDataToUserDefaults(data: PhotoViewController.searchQueryArray as AnyObject, key: "queryArray")
    }
}

extension PhotoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.searchTextField.text else { return }
        self.helpLabel.isHidden = true
        self.suggestionTableView.isHidden = true
        presenter?.clearPhotoDataArray()
        searchText = query
        page = 1
        callSearchApi(pagination: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty ?? false {
            helpLabel.isHidden = false
            responseObject = nil
            photoDataObject = nil
            self.suggestionTableView.isHidden = true
            photoCollectionView.reloadData()
        } else {
            self.suggestionTableView.isHidden = false
            suggestionTableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setUpTableView()
    }
}
