//
//  GithubLocalDataSource.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import RxSwift

public class GithubLocalDataSource: DataSource {
    var apiClient: APIClient
    
    init() {
        self.apiClient = APIClient.shared
    }
    
    func getGithubUserList(page: Int) -> Observable<[GithubUser]> {
        return Observable.just([])
    }
    
    func getGitubUserList(since: Int, completionHandler: @escaping NetworkCompletionHandler<[GithubUser]>) {
        
    }
}
