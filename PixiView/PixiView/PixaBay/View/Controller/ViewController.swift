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
    
    var presenter: PhotoDataPresenter?
    var photoArray = [UIImage]()
    
    var imgArray: [UIImage] {
        get {
            return presenter?.getPhotoArray() ?? [UIImage]()
        }
        set {
            self.photoArray = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.presenter = PhotoDataPresenter(controller: self)
        setUpCollectionView()
        callSearchApi()
    }
    
    func setUpCollectionView() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
    }
    
    func callSearchApi() {
        presenter?.getSearchResult(searchKey: "yellow") { (success) in
            if success {
                self.photoCollectionView.reloadData()
            }
        }
    }
    
}
