//
//  UIImageView+Extension.swift
//  tawktestios
//
//  Created by JMC on 28/7/21.
//

import UIKit

extension UIImageView {
    func loadImage(from url: String, placeholderImage: UIImage? = UIImage(named: "img_avatar"), completionHandler: @escaping (ImageDownloadCompletionHandler)){
        
        self.image = placeholderImage
        ImageDownloader.shared.downloadImage(with: url, completionHandler: completionHandler, placeholderImage: placeholderImage)
    }
}

