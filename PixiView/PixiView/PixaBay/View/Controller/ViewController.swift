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
    
    var presenter: PhotoDataPresenter?
    var responseObject: PhotoResponse?
    var pageViewController: UIPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "PixiView"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.presenter = PhotoDataPresenter(controller: self)
        helpLabel.isHidden = false
        setUpCollectionView()
        setUpSearchBar()
    }
    
    func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func setUpCollectionView() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
    
    func callSearchApi(query: String) {
        presenter?.getSearchResult(searchKey: query) { (success) in
            if success {
                self.responseObject = self.presenter?.getResponseObject()
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    func showAlertOnNoResults() {
        let alert = UIAlertController(title: "Oops!", message: "We could not find what you are looking for, try searching something else.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.searchTextField.text else { return }
        self.helpLabel.isHidden = true
        callSearchApi(query: query)
    }
    
}
