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
    
    func send<T: Codable>(apiRequest: APIRequest, type: T.Type, completeionHandler: @escaping (Result<T, NetworkError>) -> Void){
        let session = URLSession.shared
        let request = apiRequest.request(with: apiRequest.baseURL)
           
//       var request = URLRequest(url: url)
//       request.httpMethod = "GET"
//       request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { data, response, error in

           guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completeionHandler(.failure(.serverError))
                return
           }

           guard let mime = response.mimeType, mime == "application/json" else {
                completeionHandler(.failure(.wrongMimeTypeError))
                return
           }

           guard let responseData = data else{
                completeionHandler(.failure(.noDataError))
                return
           }
            
            let resultjson = try? JSONDecoder().decode(T.self, from: responseData)
           
            if let result = resultjson{
                completeionHandler(.success(result))
            }else{
                completeionHandler(.failure(.decodingError))
            }
       }

       task.resume()
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
