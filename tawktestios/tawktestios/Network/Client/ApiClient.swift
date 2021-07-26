//
//  ApiClient.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import RxSwift
import RxCocoa

class APIClient {
    public static let shared = APIClient()
    private let queueManager: QueueManager
    
    func send<T: Codable>(apiRequest: APIRequest, type: T.Type) -> Observable<T> {
        let request = apiRequest.request(with: apiRequest.baseURL)
        
        return URLSession.shared.rx.data(request: request)
            .map { data in
                try JSONDecoder().decode(T.self, from: data)
            }.observe(on: MainScheduler.asyncInstance)
    }
    
    init(withQueueManager queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    func enqueue<T: Codable>(apiRequest: APIRequest, type: T.Type) -> Observable<T> {
//        let request = apiRequest.request(with: apiRequest.baseURL)
        
        let operation = NetworkOperation()
//        operation.completionHandler = completionHandler
        let result = operation.execute(apiRequest: apiRequest, type: type)
        queueManager.enqueue(operation)
        
        return result

//        return URLSession.shared.rx.data(request: request)
//            .map { data in
//                try JSONDecoder().decode(T.self, from: data)
//            }.observe(on: MainScheduler.asyncInstance)
    }
}
