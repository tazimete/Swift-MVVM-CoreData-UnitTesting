//
//  ImageDownloaderClient.swift
//  tawktestios
//
//  Created by JMC on 14/8/21.
//

import Foundation
import UIKit


public class ImageDownloadresResponse {
    public var url: String?
    public var image: UIImage?
    public var isCached: Bool?
    
    init(url: String? = nil, image: UIImage? = nil, isCached: Bool? = nil) {
        self.url = url
        self.image = image
        self.isCached = isCached
    }
}

public class ImageDownloaderClient{
    public static let shared = ImageDownloaderClient()
    public var queueManager: QueueManager

    
    public init(withQueueManager queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    public func enqueue(session: URLSession, downloadTaskURL: URL, completionHandler: @escaping ImageDownloadResultHandler) {
        let operation = NetworkOperation(session: session, downloadTaskURL: downloadTaskURL, completionHandler: completionHandler)
        operation.qualityOfService = .utility
        queueManager.enqueue(operation)
    }
}
