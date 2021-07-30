//
//  ApiClient.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case serverError
    case decodingError
    case wrongMimeTypeError
    case noDataError
}

typealias NetworkCompletionHandler<T: Codable> = (Result<T, NetworkError>) -> Void
typealias ImageDownloadCompletionHandler = ((String, UIImage?, Bool) -> Void)


class APIClient {
    public static let shared = APIClient()
    private let queueManager: QueueManager

    
    init(withQueueManager queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    func enqueue<T: Codable>(apiRequest: APIRequest, type: T.Type, completionHandler: @escaping (NetworkCompletionHandler<T>)) {
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
