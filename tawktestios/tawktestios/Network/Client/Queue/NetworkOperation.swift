//
//  NetworkOperation.swift
//  tawktestios
//
//  Created by JMC on 25/7/21.
//

import Foundation

public class NetworkOperation: Operation {
    
    private var task: URLSessionTask?
    
    enum OperationState: Int {
        case ready
        case executing
        case finished
    }
    
    // default state is ready (when the operation is created)
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override public var isReady: Bool { return state == .ready }
    override public var isExecuting: Bool { return state == .executing }
    override public var isFinished: Bool { return state == .finished }
    
    public override init() {
        super.init()
    }
    
    public init<T: Codable>(apiRequest: APIRequest, type: T.Type, completionHandler: @escaping (NetworkCompletionHandler<T>)){
        super.init()
    
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
//        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = nil

        let session = URLSession(configuration: config)
        let request = apiRequest.request(with: apiRequest.baseURL)

        task = session.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                     completionHandler(.failure(.serverError))
                     self?.state = .finished
                     return
                }

                guard let mime = response.mimeType, mime == "application/json" else {
                     completionHandler(.failure(.wrongMimeTypeError))
                     self?.state = .finished
                     return
                }

                guard let responseData = data else{
                     completionHandler(.failure(.noDataError))
                     self?.state = .finished
                     return
                }
                 
                 let resultData = try? JSONDecoder().decode(T.self, from: responseData)
                
                 if let result = resultData{
                     completionHandler(.success(result))
                 }else{
                     completionHandler(.failure(.decodingError))
                 }
                
                 self?.state = .finished
            }
       }
    }
    
    public init(session: URLSession, downloadTaskURL: URL, completionHandler: ((URL?, URLResponse?, Error?) -> Void)?) {
           super.init()

           // use weak self to prevent retain cycle
           task = session.downloadTask(with: downloadTaskURL, completionHandler: { [weak self] (localURL, response, error) in
                    DispatchQueue.main.async {
                        /*
                        if there is a custom completionHandler defined,
                        pass the result gotten in downloadTask's completionHandler to the
                        custom completionHandler
                        */
                        if let completionHandler = completionHandler {
                            // localURL is the temporary URL the downloaded file is located
                            completionHandler(localURL, response, error)
                        }

                       /*
                         set the operation state to finished once
                         the download task is completed or have error
                       */
                        self?.state = .finished
                    }
           })
       }
    
    override public func start() {
        if(self.isCancelled) {
            state = .finished
            return
        }
        
        // set the state to executing
        state = .executing
        
        print("Processing \(self.task?.originalRequest?.url?.absoluteString ?? "")")
            
        // start the downloading
        self.task?.resume()
    }
    
    override public func cancel() {
        super.cancel()
        self.task?.cancel()
    }
    
    public func getStubbResponse<T: Codable>(type: T.Type, completionHandler: @escaping (NetworkCompletionHandler<T>)){
        guard let response = ((StubResponseProvider.get(type: type)[0])["response"]) else {
            completionHandler(.failure(.noDataError))
            return
        }
        guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) else {
            completionHandler(.failure(.noDataError))
            return
        }
        
        guard let resultData = try? JSONDecoder().decode(T.self, from: data) else {
            completionHandler(.failure(.decodingError))
            return
        }
        
        completionHandler(.success(resultData))
    }
}



func testNetworkOperation() {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1

    let urls = [
        URL(string: "https://github.com/fluffyes/AppStoreCard/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/currentLocation/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/DispatchQueue/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/dynamicFont/archive/master.zip")!,
        URL(string: "https://github.com/fluffyes/telegrammy/archive/master.zip")!
    ]

    for url in urls {
        let operation = NetworkOperation(session: URLSession.shared, downloadTaskURL: url, completionHandler: { (localURL, response, error) in
            print("finished downloading \(url.absoluteString)")
        })

        queue.addOperation(operation)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now()+150, execute: {
        let url = URL(string: "https://github.com/fluffyes/AppStoreCard/archive/master.zip")! 
        let operation = NetworkOperation(session: URLSession.shared, downloadTaskURL: url, completionHandler: { (localURL, response, error) in
            print("finished downloading ## -- \(url.absoluteString) -- queue count = \(queue.operations.count)")
        })
        queue.addOperation(operation)
    })
}
