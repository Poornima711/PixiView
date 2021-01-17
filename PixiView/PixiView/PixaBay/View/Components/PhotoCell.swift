//
//  PhotoCollectionViewCell.swift
//  PixiView
//
//  Created by tcs on 15/01/21.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var imageView: CustomImageView!
    
    @IBInspectable var borderWidth: CGFloat = 1
    @IBInspectable var borderColor: UIColor = .lightGray
    
    func setUIForCell() {
        self.innerView.layer.borderWidth = borderWidth
        self.innerView.layer.borderColor = borderColor.cgColor
    }
}
