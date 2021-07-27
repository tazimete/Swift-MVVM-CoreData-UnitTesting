//
//  GithubDataSource.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import RxSwift

public class GithubRemoteDataSource: DataSource {
    var apiClient: APIClient
    
    init() {
        self.apiClient = APIClient.shared
    }
    
//    func getGithubUserList(page: Int) -> Observable<[GithubUser]> {
//        return apiClient.send(apiRequest: GithubApiRequest.fetchUserList(params: FetchGithubUserParams(since: page)), type: [GithubUser].self)
//    }
    
    func getGitubUserList(since: Int, completionHandler: @escaping (NetworkCompletionHandler<[GithubUser]>)) {
//        apiClient.send(apiRequest: GithubApiRequest.fetchUserList(params: FetchGithubUserParams(since: since)), type: [GithubUser].self, completionHandler: completionHandler)
        apiClient.enqueue(apiRequest: GithubApiRequest.fetchUserList(params: FetchGithubUserParams(since: since)), type: [GithubUser].self, completionHandler: completionHandler)
    }
}

