//
//  ViewController.swift
//  PixiView
//
//  Created by Poornima Rao on 15/01/21.
//

import UIKit

/**
    This class is a view controller class.
    - Configures SearchBar and Implements UISearchBarDelegate methods
    - Configures UICollectionView and Implements UICollectionView datasource and delegate methods
    - Configures UITableView and Implements UITableView datasource and delegate methods
*/

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: PhotoDataPresenter?
    var responseObject: PhotoResponse?
    var photoDataObject: [PhotoData]?
    var pageViewController: UIPageViewController?
    var totalImages: Int?
    var page = 1
    var isNewSearch = false
    var searchText: String = ""
    var rowHeight: CGFloat = 30.0
    static var searchQueryArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "PixiView"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.presenter = PhotoDataPresenter(controller: self)
        activityIndicator.isHidden = true
        suggestionTableView.register(UINib(nibName: "QueryTableViewCell", bundle: nil), forCellReuseIdentifier: "QueryTableViewCell")
        helpLabel.isHidden = false
        tapView.isHidden = true
        setUpCollectionView()
        addTapGesture()
        setUpSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        suggestionTableView.isHidden = true
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        tapView.isHidden = true
    }
    
    /**
        Set up SearchBar.
    */
    func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    /**
        Set up CollectionView.
    */
    func setUpCollectionView() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
    
    /**
        Call Search API.
        - Parameter pagination: Boolean value specifies whether pagination needed or not
    */
    func callSearchApi(pagination: Bool) {
        self.activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        presenter?.getSearchResult(searchKey: searchText, pageNumber: page, pagination: pagination) { [weak self] (success)  in
            if success {
                self?.responseObject = self?.presenter?.getResponseObject()
                self?.photoDataObject = self?.presenter?.getPhotoDataObject()
                self?.totalImages = self?.responseObject?.totalHits
                self?.presenter?.fillSearchArray(searchText: self?.searchText ?? "")
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                self?.photoCollectionView.reloadData()
            } else {
                if self?.page == 1 { 
                    self?.showAlert(title: "Oops!", message: "We could not find what you are looking for, try searching something else.")
                }
            }
        }
    }
    
    /**
        Show alert when no Error.
        - Parameter title: Alert Title
        - Parameter message: Alert Message
    */
    func showAlert(title: String, message: String) {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension PhotoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.searchTextField.text else { return }
        self.helpLabel.isHidden = true
        self.view.endEditing(true)
        isNewSearch = true
        tapView.isHidden = true
        self.suggestionTableView.isHidden = true
        presenter?.clearPhotoDataArray()
        searchText = query
        page = 1
        callSearchApi(pagination: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tapView.isHidden = false
        if searchBar.text?.isEmpty ?? false {
            helpLabel.isHidden = false
            responseObject = nil
            photoDataObject = nil
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            self.suggestionTableView.isHidden = true
            photoCollectionView.reloadData()
        } else {
            self.suggestionTableView.isHidden = false
            presenter?.clearPhotoDataArray()
            isNewSearch = true
            suggestionTableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tapView.isHidden = false
        setUpTableView()
    }
}
