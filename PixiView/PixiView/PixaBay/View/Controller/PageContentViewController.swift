//
//  ImageViewController.swift
//  PixiView
//
//  Created by Poornima Rao on 16/01/21.
//

import UIKit
/**
    This is Page Content Controller class.
    - sets the full image to the image view

 */
class PageContentViewController: UIViewController {

    @IBOutlet var imgView: CustomImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //variable declarations
    var index: Int = 0
    var url: String = ""
    var numberOfPages: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation appearance details
        self.title = "PixiView"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // start loader
        startLoader()
        
        //download image
        if NetworkManagerClass.sharedInstance.isReachability {
            self.imgView.loadThumbnail(urlString: url,activityIndicator: self.activityIndicator) { [weak self] (_) in
                //stop loader
                self?.stopLoader()
            }
        } else {
            self.showAlert(title: ErrorMessages.networkUnreachable.rawValue, message: "")
        }
    }
    
    /**
        The method starts animating the activity indicator.
     */
    func startLoader() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    /**
        The method stops animating the activity indicator.
     */
    func stopLoader() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    /**
        Show alert when no Error.
        - Parameter title: Alert Title
        - Parameter message: Alert Message
    */
    func showAlert(title: String, message: String) {
        stopLoader()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}
