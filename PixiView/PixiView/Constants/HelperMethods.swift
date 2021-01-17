//
//  HelperMethods.swift
//  PixiView
//
//  Created by tcs on 17/01/21.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.masksToBounds = true
        self.clipsToBounds = false
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addBorder(width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
