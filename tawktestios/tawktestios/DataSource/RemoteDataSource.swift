//
//  GithubDataSource.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation


/*
 This is the abstraction of our Remote data source of our project, It uses generic data model to fetch certain request
 and write response data to certain model. It fetches two types of data (Array ob objects and single object). Request must be type of APIRequest and Data model must be conformed from AbstractDataModel
 */

public class RemoteDataSource<T: APIRequest, D: AbstractDataModel & Codable>: AbstractRemoteDataSource{
    public typealias T = T
    public typealias D = D
    
    public var apiClient: AbstractApiClient
    
    public init(apiClient: AbstractApiClient = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    public func fetchData(request: T, completionHandler: @escaping NetworkCompletionHandler<D>) {
        apiClient.enqueue(apiRequest: request, type: D.self, completionHandler: completionHandler)
    }

    public func fetchDataList(request: T, completionHandler: @escaping NetworkCompletionHandler<[D]>) {
        apiClient.enqueue(apiRequest: request, type: [D].self, completionHandler: completionHandler)
    }
}




