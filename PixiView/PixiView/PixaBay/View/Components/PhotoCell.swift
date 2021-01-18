//
//  PhotoCollectionViewCell.swift
//  PixiView
//
//  Created by Poornima Rao on 15/01/21.
//

import UIKit

/**
    Search Collection View Cell Class.
*/
class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var imageView: CustomImageView!
    
    @IBInspectable var borderWidth: CGFloat = 1
    @IBInspectable var borderColor: UIColor = .lightGray
    
    /**
        Set UI for the cell.
    */
    func setUIForCell() {
        self.innerView.layer.borderWidth = borderWidth
        self.innerView.layer.borderColor = borderColor.cgColor
    }
}
