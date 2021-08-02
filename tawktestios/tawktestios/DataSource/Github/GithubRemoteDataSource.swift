//
//  GithubDataSource.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation

//public class GithubRemoteDataSource: RemoteDataSource {
//    var apiClient: APIClient
//
//    init() {
//        self.apiClient = APIClient.shared
//    }
//
//    func getGitubUserList(since: Int, completionHandler: @escaping (NetworkCompletionHandler<[GithubUser]>)) {
//        apiClient.enqueue(apiRequest: GithubApiRequest.fetchUserList(params: FetchGithubUserParams(since: since)), type: [GithubUser].self, completionHandler: completionHandler)
//    }
//}


class RemoteDataSource<T: APIRequest, D: AbstractDataModel & Codable>: AbstractRemoteDataSource{
    typealias T = T
    typealias D = D
    
    var apiClient: APIClient
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func fetchData(request: T, completionHandler: @escaping NetworkCompletionHandler<D>) {
        apiClient.enqueue(apiRequest: request, type: D.self, completionHandler: completionHandler)
    }

    func fetchDataList(request: T, completionHandler: @escaping NetworkCompletionHandler<[D]>) {
        apiClient.enqueue(apiRequest: request, type: [D].self, completionHandler: completionHandler)
    }
}
