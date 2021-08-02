//
//  ApiClient.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import UIKit

public enum NetworkError: Error {
    case serverError
    case decodingError
    case wrongMimeTypeError
    case noDataError
}

public typealias NetworkCompletionHandler<T: Codable> = (Result<T, NetworkError>) -> Void
public typealias ImageDownloadCompletionHandler = ((String, UIImage?, Bool) -> Void)


public class APIClient {
    public static let shared = APIClient()
    private let queueManager: QueueManager

    
    public init(withQueueManager queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    public func enqueue<T: Codable>(apiRequest: APIRequest, type: T.Type, completionHandler: @escaping (NetworkCompletionHandler<T>)) {
        let operation = NetworkOperation(apiRequest: apiRequest, type: type, completionHandler: completionHandler)
        operation.qualityOfService = .utility
        queueManager.enqueue(operation)
    }
    
//    func enqueue<T: Codable>(session: URLSession, url: URL, completionHandler: @escaping (DownloadCompletionHandler)) {
//        let operation = NetworkOperation(session: session, downloadTaskURL: url, completionHandler: completionHandler)
////        operation.completionHandler = completionHandler
//        operation.qualityOfService = .utility
//        queueManager.enqueue(operation)
//    }
}
