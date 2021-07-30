//
//  UIImageView+Extension.swift
//  tawktestios
//
//  Created by JMC on 28/7/21.
//

import UIKit

extension UIImageView {
    func loadImage(from url: String, placeholderImage: UIImage? = UIImage(named: "img_avatar"), completionHandler: @escaping (ImageDownloadCompletionHandler)){
        ImageDownloader.shared.downloadImage(with: url, completionHandler: completionHandler, placeholderImage: placeholderImage)
        
//        ImageLoader.shared.loadImage(from: URL(string: url)!, completionHandler: {
//            (image, cached) in
//            self.image = image
//        }, placeholderImage: UIImage(named: "img_avatar"))
        
//        ImageCacheLoader.shared.obtainImageWithPath(imagePath: url) { (image) in
//                // Before assigning the image, check whether the current cell is visible for ensuring that it's right cell
//            self.image = image
//        }
    }
}
