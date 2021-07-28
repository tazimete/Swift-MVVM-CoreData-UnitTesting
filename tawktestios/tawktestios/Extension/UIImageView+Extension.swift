//
//  UIImageView+Extension.swift
//  tawktestios
//
//  Created by JMC on 28/7/21.
//

import UIKit

extension UIImageView {
    public func loadImage(from url: String, placeholderImage: UIImage? = UIImage(named: "img_avatar")){
        ImageDownloader.shared.downloadImage(with: url, completionHandler: { (image, cached) in
            self.image = image
        }, placeholderImage: placeholderImage)
        
//        ImageLoader.shared.loadImage(from: URL(string: url)!, completionHandler: {
//            (image, cached) in
//            self.image = image
//        }, placeholderImage: UIImage(named: "img_avatar"))
    }
    
    
}
