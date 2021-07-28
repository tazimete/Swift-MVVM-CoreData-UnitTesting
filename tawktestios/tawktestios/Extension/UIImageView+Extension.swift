//
//  UIImageView+Extension.swift
//  tawktestios
//
//  Created by JMC on 28/7/21.
//

import UIKit

extension UIImageView {
    public func loadImage(from url: String){
        ImageDownloader.shared.downloadImage(with: url, completionHandler: { (image, cached) in
            self.image = image
        }, placeholderImage: UIImage(named: "img_avatar"))
        
//        ImageLoader.shared.loadImage(from: URL(string: url)!, completionHandler: {
//            (image, cached) in
//            self.image = image
//        }, placeholderImage: UIImage(named: "img_avatar"))
    }
    
    
}
