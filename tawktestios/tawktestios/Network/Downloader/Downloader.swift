//
//  ImageDownloader.swift
//  tawktestios
//
//  Created by JMC on 28/7/21.
//

import Foundation
import UIKit

public class Downloader<T>: AbstractDownloader {
    public typealias T = T
//    static let shared = Downloader<UIImage>()
    public var downloaderClient: AbstractDownloaderClient
    public var serialQueueForData = DispatchQueue(label: "datas.queue", attributes: .concurrent)
    public var serialQueueForDataTasks = DispatchQueue(label: "dataTasks.queue", attributes: .concurrent)
    public var cachedDataList: [String: T]
    public var dataDownloadSessionList: [String: URLSession]
    
    // MARK: Private init
    public init() {
        cachedDataList = [:]
        dataDownloadSessionList = [:]
        downloaderClient = DownloaderClient.shared
    }
    
    public func download(with urlString: String?, completionHandler: @escaping (DownloadCompletionHandler<T>), placeholderImage: T?) {
        
        guard let urlString = urlString else {
            completionHandler("", placeholderImage, false)
            return
        }
        
        if let image = getCachedDataFrom(urlString: urlString) {
            completionHandler(urlString, image, true)
        } else {
            guard let url = URL(string: urlString) else {
                completionHandler(urlString, placeholderImage, false)
                return
            }
            
            if let cachedTask = getDataTaskFrom(urlString: urlString) {
                return
            }
            
            let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let diskCacheURL = cachesURL.appendingPathComponent("DownloadCache")
            let cache = URLCache(memoryCapacity: 10_000_0000, diskCapacity: 1_000_000_0000, directory: diskCacheURL)
            let config = URLSessionConfiguration.default
            config.urlCache = cache
            let session = URLSession(configuration: config)
            
            downloaderClient.enqueue(session: session, downloadTaskURL: url, completionHandler: {
                [weak self] result in
                
                //handle result
                self?.handleDownloadResult(result: result, placeholderImage: placeholderImage, completionHandler: completionHandler)
            })
            
            // We want to control the access to no-thread-safe dictionary in case it's being accessed by multiple threads at once
            self.serialQueueForDataTasks.sync(flags: .barrier) {
                dataDownloadSessionList[urlString] = session
            }
        }
    }
    
    
    private func handleDownloadResult(result: Result<DownloaderResponse, NetworkError>, placeholderImage: T?, completionHandler: @escaping (DownloadCompletionHandler<T>)) {
        switch result {
            case .success(let response):
                guard  let data = response.data else {
                    completionHandler(response.url ?? "", placeholderImage, response.isCached ?? false)
                    return
                }
                
                let image = UIImage(data: data)?.decodedImage()
                completionHandler(response.url ?? "", image as! T ?? placeholderImage, response.isCached ?? false)
                
                // Store the downloaded image in cache
                self.serialQueueForData.sync(flags: .barrier) {
                    self.cachedDataList[response.url ?? ""] = image as! T
                }

                // Clear out the finished task from download tasks container
                _ = self.serialQueueForDataTasks.sync(flags: .barrier) {
                    self.dataDownloadSessionList.removeValue(forKey: response.url ?? "")
                }
                
                break
                
            case .failure(let error):
                completionHandler("", placeholderImage, false)
                break
        }
    }
    
    public func getCachedDataFrom(urlString: String) -> T? {
        // Reading from the dictionary should happen in the thread-safe manner.
        serialQueueForData.sync {
            return cachedDataList[urlString]
        }
    }
    
    public func getDataTaskFrom(urlString: String) -> URLSession? {
        // Reading from the dictionary should happen in the thread-safe manner.
        serialQueueForDataTasks.sync {
            return dataDownloadSessionList[urlString]
        }
    }
}
