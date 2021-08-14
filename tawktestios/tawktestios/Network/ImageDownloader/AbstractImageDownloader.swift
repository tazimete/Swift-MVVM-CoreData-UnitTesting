//
//  AbstractImageDownloader.swift
//  tawktestios
//
//  Created by JMC on 15/8/21.
//

import UIKit

public typealias ImageDownloadCompletionHandler = (String, UIImage?, Bool) -> Void

public protocol AbstractImageDownloader: AnyObject {
    var serialQueueForImages: DispatchQueue {set get}
    var serialQueueForDataTasks: DispatchQueue {set get}
    var cachedImages: [String: UIImage] {set get}
    var imagesDownloadTasks: [String: URLSession] {set get}
    
    func downloadImage(with imageUrlString: String?, completionHandler: @escaping (ImageDownloadCompletionHandler), placeholderImage: UIImage?)
    func getCachedImageFrom(urlString: String) -> UIImage?
    func getDataTaskFrom(urlString: String) -> URLSession?
}
