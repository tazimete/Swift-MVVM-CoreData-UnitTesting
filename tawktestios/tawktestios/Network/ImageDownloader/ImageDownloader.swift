//
//  ImageDownloader.swift
//  tawktestios
//
//  Created by JMC on 28/7/21.
//

import Foundation
import UIKit


final class ImageDownloader: AbstractImageDownloader {
    static let shared = ImageDownloader()
    public let downloaderClient = DownloaderClient.shared
    internal var serialQueueForImages = DispatchQueue(label: "images.queue", attributes: .concurrent)
    internal var serialQueueForDataTasks = DispatchQueue(label: "dataTasks.queue", attributes: .concurrent)
    internal var cachedImages: [String: UIImage]
    internal var imagesDownloadTasks: [String: URLSession]
    
    // MARK: Private init
    private init() {
        cachedImages = [:]
        imagesDownloadTasks = [:]
    }
    
    public func downloadImage(with imageUrlString: String?, completionHandler: @escaping (ImageDownloadCompletionHandler), placeholderImage: UIImage?) {
        
        guard let imageUrlString = imageUrlString else {
            completionHandler("", placeholderImage, false)
            return
        }
        
        if let image = getCachedImageFrom(urlString: imageUrlString) {
            completionHandler(imageUrlString, image, true)
        } else {
            guard let url = URL(string: imageUrlString) else {
                completionHandler(imageUrlString, placeholderImage, false)
                return
            }
            
            if let cachedTask = getDataTaskFrom(urlString: imageUrlString) {
                return
            }
            
            let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let diskCacheURL = cachesURL.appendingPathComponent("DownloadCache")
            let cache = URLCache(memoryCapacity: 10_000_0000, diskCapacity: 1_000_000_0000, directory: diskCacheURL)
            let config = URLSessionConfiguration.default
            config.urlCache = cache
            let session = URLSession(configuration: config)
            
            downloaderClient.enqueue(session: session, downloadTaskURL: url, completionHandler: {
                result in
                
                switch result {
                    case .success(let response):
                        guard  let data = response.data else {
                            completionHandler(response.url ?? "", placeholderImage, response.isCached ?? false)
                            return
                        }
                        
                        let image = UIImage(data: data)?.decodedImage()
                        completionHandler(response.url ?? "", image ?? placeholderImage, response.isCached ?? false)
                        
                        // Store the downloaded image in cache
                        self.serialQueueForImages.sync(flags: .barrier) {
                            self.cachedImages[imageUrlString] = image
                        }
        
                        // Clear out the finished task from download tasks container
                        _ = self.serialQueueForDataTasks.sync(flags: .barrier) {
                            self.imagesDownloadTasks.removeValue(forKey: response.url ?? "")
                        }
                        
                        break
                        
                    case .failure(let error):
                        completionHandler("", placeholderImage, false)
                        break
                }
            })
            
            // We want to control the access to no-thread-safe dictionary in case it's being accessed by multiple threads at once
            self.serialQueueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks[imageUrlString] = session
            }
        }
    }
    
    
    internal func getCachedImageFrom(urlString: String) -> UIImage? {
        // Reading from the dictionary should happen in the thread-safe manner.
        serialQueueForImages.sync {
            return cachedImages[urlString]
        }
    }
    
    internal func getDataTaskFrom(urlString: String) -> URLSession? {
        // Reading from the dictionary should happen in the thread-safe manner.
        serialQueueForDataTasks.sync {
            return imagesDownloadTasks[urlString]
        }
    }
}

