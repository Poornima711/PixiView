//
//  ImageViewController.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    //@IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    //@IBOutlet weak var imageViewTop: NSLayoutConstraint!
    
    //variable declarations
    var index: Int = 0
    var image: UIImage!
    var url: String = ""
    var name: String = ""
    var pointToCenterAfterResize: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setImage(image: UIImage) {
        self.imageView.image = image
    }
    
}
