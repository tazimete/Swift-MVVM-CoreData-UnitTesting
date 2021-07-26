//
//  ApiClient.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import RxSwift
import RxCocoa

class ApiClientError: Error {
    let code:Int
    let message: String
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
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
    
    func send<T: Codable>(apiRequest: APIRequest, type: T.Type, completeionHandler: @escaping (_ response: T?, _ error: Error?) -> Void){
        let session = URLSession.shared
        let request = apiRequest.request(with: apiRequest.baseURL)
           
//       var request = URLRequest(url: url)
//       request.httpMethod = "GET"
//       request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { data, response, error in

           if error != nil || data == nil {
               print("Client error!")
               return
           }

           guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
               print("Server error!")
               return
           }

           guard let mime = response.mimeType, mime == "application/json" else {
               print("Wrong MIME type!")
               return
           }

           guard let responseData = data else{
               print("No data")
               return
           }
            
            let resultjson = try? JSONDecoder().decode(T.self, from: responseData)
           
            if let result = resultjson{
                completeionHandler(result, nil)
            }else{
                let error = ApiClientError(code: 100, message: "Error response")
                completeionHandler(nil, error)
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
