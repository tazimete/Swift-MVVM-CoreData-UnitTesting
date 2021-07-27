//
//  ApiClient.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import RxSwift
import RxCocoa

enum NetworkError: Error {
    case serverError
    case decodingError
    case wrongMimeTypeError
    case noDataError
}

typealias NetworkCompletionHandler<T: Codable> = (Result<T, NetworkError>) -> Void


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
    
    func send<T: Codable>(apiRequest: APIRequest, type: T.Type, completionHandler: @escaping (NetworkCompletionHandler<T>)){
        let session = URLSession.shared
        let request = apiRequest.request(with: apiRequest.baseURL)

        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                     completionHandler(.failure(.serverError))
                     return
                }

                guard let mime = response.mimeType, mime == "application/json" else {
                     completionHandler(.failure(.wrongMimeTypeError))
                     return
                }

                guard let responseData = data else{
                     completionHandler(.failure(.noDataError))
                     return
                }
                 
                 let resultjson = try? JSONDecoder().decode(T.self, from: responseData)
                
                 if let result = resultjson{
                     completionHandler(.success(result))
                 }else{
                     completionHandler(.failure(.decodingError))
                 }
            }
       }

       task.resume()
    }
    
    init(withQueueManager queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    func enqueue<T: Codable>(apiRequest: APIRequest, type: T.Type, completionHandler: @escaping (NetworkCompletionHandler<T>)) {
//        let request = apiRequest.request(with: apiRequest.baseURL)
        
        let operation = NetworkOperation(apiRequest: apiRequest, type: type, completionHandler: completionHandler)
//        operation.completionHandler = completionHandler
//        operation.execute()
        queueManager.enqueue(operation)
    }
}
