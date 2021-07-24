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
    
    func getGithubUserList(page: Int) -> Observable<[GithubUser]> {
        return apiClient.send(apiRequest: GithubApiRequest.fetchUserList(params: FetchGithubUserParams(since: page)), type: [GithubUser].self)
    }
}

