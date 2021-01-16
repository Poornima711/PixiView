//
//  PhotoCollectionViewCell.swift
//  PixiView
//
//  Created by tcs on 15/01/21.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override class func awakeFromNib() {
        //
    }
    
    func setDataToCell(index: Int, photoArray: [UIImage]) {
        if !photoArray.isEmpty {
            self.imageView.image = photoArray[index]
        }
    }
}
