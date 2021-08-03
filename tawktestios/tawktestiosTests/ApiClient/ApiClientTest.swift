//
//  ApiClientTest.swift
//  tawktestiosTests
//
//  Created by JMC on 3/8/21.
//

import Foundation
import tawktestios

class ApiClientTest: AbstractApiClient {
    public static let shared = ApiClientTest()
    public var queueManager: QueueManager

    public init(withQueueManager queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    public func enqueue<T: Codable>(apiRequest: APIRequest, type: T.Type, completionHandler: @escaping (NetworkCompletionHandler<T>)) {
        let operation = NetworkOperation()
        operation.qualityOfService = .utility
        queueManager.enqueue(operation)
        operation.getStubbResponse(type: type, completionHandler: completionHandler)
    }
}
