//
//  UIImage+Additions.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import Foundation
import UIKit

extension UIImageView {

    func setImage(from url: URL, placeholder: UIImage? = nil) {
        image = placeholder               // use placeholder (or if `nil`, remove any old image, before initiating asynchronous retrieval

//        ImageCache.shared.image(for: url) { [weak self] result in
//            switch result {
//            case .success(let image):
//                self?.image = image
//
//            case .failure:
//                break
//            }
//        }
    }
}
