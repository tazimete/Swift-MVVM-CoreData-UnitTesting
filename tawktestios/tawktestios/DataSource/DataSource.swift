//
//  AbstractDataSource.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation

protocol DataSource: AnyObject {
    var apiClient: APIClient {set get}
    
    func getGitubUserList(since: Int, completionHandler: @escaping NetworkCompletionHandler<[GithubUser]>)
}
