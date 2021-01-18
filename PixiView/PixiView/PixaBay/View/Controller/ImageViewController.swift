//
//  ImageViewController.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet var imgView: CustomImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //variable declarations
    var index: Int = 0
    var url: String = ""
    var numberOfPages: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        pageControl.currentPageIndicatorTintColor = .yellow
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.tintColor = .gray
        pageControl.currentPage = index
        pageControl.numberOfPages = numberOfPages ?? 1
        startLoader()
        self.imgView.loadThumbnail(urlString: url) { (_) in
            self.stopLoader()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageControlSetUp()
    }
    
    func startLoader() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoader() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    fileprivate func pageControlSetUp() {
        pageControl?.numberOfPages = numberOfPages ?? 1
        pageControl?.currentPage = index
    }
}
