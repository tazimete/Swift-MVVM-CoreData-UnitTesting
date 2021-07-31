//
//  GithubDataSource.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation

public class GithubRemoteDataSource: RemoteDataSource {
    var apiClient: APIClient
    
    init() {
        self.apiClient = APIClient.shared
    }
    
    func getGitubUserList(since: Int, completionHandler: @escaping (NetworkCompletionHandler<[GithubUser]>)) {
        apiClient.enqueue(apiRequest: GithubApiRequest.fetchUserList(params: FetchGithubUserParams(since: since)), type: [GithubUser].self, completionHandler: completionHandler)
    }
}

