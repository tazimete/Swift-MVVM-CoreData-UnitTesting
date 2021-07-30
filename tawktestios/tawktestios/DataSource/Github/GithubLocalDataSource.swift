//
//  GithubLocalDataSource.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation

public class GithubLocalDataSource: DataSource {
    var apiClient: APIClient
    
    init() {
        self.apiClient = APIClient.shared
    }
    
    func getGitubUserList(since: Int, completionHandler: @escaping NetworkCompletionHandler<[GithubUser]>) {
        
    }
}
