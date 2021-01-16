//
//  BigImageCell.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import UIKit

class BigImageCell: UICollectionViewCell {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    override class func awakeFromNib() {
        //
    }
    
    func setCellData(index: Int, photoArray: [UIImage]?) {
        if let photoArray = photoArray {
            imgView.image = photoArray[index]
        }
    }
    
    func showImage(image: UIImage) {
        imgView.image = image
    }
}
