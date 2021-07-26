//
//  NetworkOperation.swift
//  tawktestios
//
//  Created by JMC on 25/7/21.
//

import Foundation
import RxSwift

class NetworkOperation: Operation {
    
    private var task: URLSessionDownloadTask!
    
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
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    override init() {
        super.init()
    }
    
//    init(session: URLSession, downloadTaskURL: URL, completionHandler: ((URL?, URLResponse?, Error?) -> Void)?) {
//           super.init()
//
//           // use weak self to prevent retain cycle
//           task = session.downloadTask(with: downloadTaskURL, completionHandler: { [weak self] (localURL, response, error) in
//
//               /*
//               if there is a custom completionHandler defined,
//               pass the result gotten in downloadTask's completionHandler to the
//               custom completionHandler
//               */
//               if let completionHandler = completionHandler {
//                   // localURL is the temporary URL the downloaded file is located
//                   completionHandler(localURL, response, error)
//               }
//
//              /*
//                set the operation state to finished once
//                the download task is completed or have error
//              */
//               self?.state = .finished
//           })
//       }
    
    public func execute<T: Codable>(apiRequest: APIRequest, type: T.Type) -> Observable<T> {
        let request = apiRequest.request(with: apiRequest.baseURL)
        
        return URLSession.shared.rx.data(request: request)
            .map { data in
                self.state = .finished
                return try JSONDecoder().decode(T.self, from: data)
            }.observe(on: MainScheduler.asyncInstance)
    }
    
    override func start() {
        if(self.isCancelled) {
            state = .finished
            return
        }
        
        // set the state to executing
        state = .executing
        
        print("downloading \(self.task.originalRequest?.url?.absoluteString ?? "")")
            
        // start the downloading
        self.task.resume()
    }
    
    override func cancel() {
        super.cancel()
        self.task.cancel()
    }
}



//func testNetworkOperation() {
//    let queue = OperationQueue()
//    queue.maxConcurrentOperationCount = 1
//
//    let urls = [
//        URL(string: "https://github.com/fluffyes/AppStoreCard/archive/master.zip")!,
//        URL(string: "https://github.com/fluffyes/currentLocation/archive/master.zip")!,
//        URL(string: "https://github.com/fluffyes/DispatchQueue/archive/master.zip")!,
//        URL(string: "https://github.com/fluffyes/dynamicFont/archive/master.zip")!,
//        URL(string: "https://github.com/fluffyes/telegrammy/archive/master.zip")!
//    ]
//
//    for url in urls {
//        let operation = NetworkOperation(session: URLSession.shared, downloadTaskURL: url, completionHandler: { (localURL, response, error) in
//            print("finished downloading \(url.absoluteString)")
//        })
//
//        queue.addOperation(operation)
//    }
//}
