//
//  ImageLoader.swift
//  tawktestios
//
//  Created by JMC on 28/7/21.
//

import UIKit

public final class ImageLoader {
    public static let shared = ImageLoader()

    private let cache: ImageCacheType
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }

    public func loadImage(from url: URL, completionHandler: @escaping (UIImage?, Bool) -> Void, placeholderImage: UIImage?) {
        if let image = cache[url] {
            completionHandler(image, true)
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(placeholderImage, false)
                return
            }
            
            if let _ = error {
                DispatchQueue.main.async {
                    completionHandler(placeholderImage, false)
                }
                return
            }
            
            let image = UIImage(data: data)?.decodedImage()
            
            // Store the downloaded image in cache
            self.cache.insertImage(image, for: url)
            
            // Always execute completion handler explicitly on main thread
            DispatchQueue.main.async {
                completionHandler(image, false)
            }
        }.resume()
    }
}
