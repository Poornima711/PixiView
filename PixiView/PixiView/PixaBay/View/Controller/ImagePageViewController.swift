//
//  ImagePageViewController.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import UIKit

class ImagePageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PixiView"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
}
