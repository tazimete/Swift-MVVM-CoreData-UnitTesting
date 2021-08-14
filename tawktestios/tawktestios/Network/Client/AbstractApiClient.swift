//
//  AbstractApiClient.swift
//  tawktestios
//
//  Created by JMC on 3/8/21.
//

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

public typealias NetworkCompletionHandler<T: Codable> = (Result<T, NetworkError>) -> Void
public typealias ImageDownloadResultHandler = (Result<ImageDownloadresResponse, NetworkError>) -> Void
public typealias ImageDownloadCompletionHandler = (String, UIImage?, Bool) -> Void

public protocol AbstractApiClient: AnyObject {
    var queueManager: QueueManager {get set}
    func enqueue<T: Codable>(apiRequest: APIRequest, type: T.Type, completionHandler: @escaping (NetworkCompletionHandler<T>))
}
