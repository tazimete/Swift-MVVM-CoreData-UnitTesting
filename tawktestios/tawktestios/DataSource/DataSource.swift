//
//  AbstractDataSource.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import RxSwift

protocol DataSource: AnyObject {
    var apiClient: APIClient {set get}
    
    func getGithubUserList(page: Int) -> Observable<[GithubUser]>
}
