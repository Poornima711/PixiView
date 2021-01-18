//
//  ImageViewController.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet var imgView: CustomImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //variable declarations
    var index: Int = 0
    var url: String = ""
    var numberOfPages: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PixiView"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        startLoader()
        self.imgView.loadThumbnail(urlString: url) { (_) in
            self.stopLoader()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func startLoader() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoader() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
