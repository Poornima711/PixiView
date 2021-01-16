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
    var responseObject: PhotoResponse?
    var pageViewController: UIPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "PixiView"
        self.presenter = PhotoDataPresenter(controller: self)
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
    
    func viewForIndex(index: Int) -> ImageViewController {
        
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        
        let pageContentObj: ImageViewController = ((storyboard.instantiateViewController(withIdentifier: "ImageViewController")) as? ImageViewController)!
        
        pageContentObj.index = index
        pageContentObj.url = self.responseObject?.hits[index].largeImageURL ?? ""
        if let url = self.responseObject?.hits[index].largeImageURL {
            self.presenter?.download(url: url, completion: { (image) in
                pageContentObj.image = image
                pageContentObj.setImage(image: image ?? UIImage())
            })
        }        
        return pageContentObj
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.searchTextField.text else { return }
        callSearchApi(query: query)
    }
    
}

extension ViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    // MARK: - paging delegates
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let temp = viewController as? ImageViewController else { return UIViewController() }
        //temp.presenter = nil
        return temp.index >= (self.responseObject?.hits.count ?? 0 - 1) ? nil: self.viewForIndex(index: temp.index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let temp = viewController as? ImageViewController else { return UIViewController() }
        //temp.presenter = nil
        return temp.index == 0 ? nil: self.viewForIndex(index: temp.index - 1)
    }
}
