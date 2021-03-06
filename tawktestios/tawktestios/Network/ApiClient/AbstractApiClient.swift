//
//  AbstractApiClient.swift
//  tawktestios
//
//  Created by JMC on 3/8/21.
//

import UIKit

public typealias NetworkCompletionHandler<T: Codable> = (Result<T, NetworkError>) -> Void

public protocol AbstractApiClient: AnyObject {
    var queueManager: QueueManager {get set}
    func enqueue<T: Codable>(apiRequest: APIRequest, type: T.Type, completionHandler: @escaping (NetworkCompletionHandler<T>))
}
