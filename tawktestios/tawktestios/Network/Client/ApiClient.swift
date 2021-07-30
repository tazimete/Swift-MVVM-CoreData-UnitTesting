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
typealias DownloadCompletionHandler = ((URL?, URLResponse?, Error?) -> Void)?
typealias ImageDownloadCompletionHandler = ((String, UIImage?, Bool) -> Void)


class APIClient {
    public static let shared = APIClient()
    private let queueManager: QueueManager
    
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
        let operation = NetworkOperation(apiRequest: apiRequest, type: type, completionHandler: completionHandler)
//        operation.completionHandler = completionHandler
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
