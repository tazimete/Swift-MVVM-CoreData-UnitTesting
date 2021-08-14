//
//  AbstractDownloader.swift
//  tawktestios
//
//  Created by JMC on 14/8/21.
//

import UIKit


public typealias ImageDownloadResultHandler<T> = (Result<ImageDownloadresResponse<T>, NetworkError>) -> Void
public typealias ImageDownloadCompletionHandler = (String, UIImage?, Bool) -> Void

public class ImageDownloadresResponse<T> {
    public var url: String?
    public var data: T?
    public var isCached: Bool?
    
    init(url: String? = nil, data: T? = nil, isCached: Bool? = nil) {
        self.url = url
        self.data = data
        self.isCached = isCached
    }
}

public protocol AbstractDownloader: AnyObject {
    associatedtype T
    var queueManager: QueueManager {get set}
    func enqueue(session: URLSession, downloadTaskURL: URL, completionHandler: @escaping ImageDownloadResultHandler<T>)
}
