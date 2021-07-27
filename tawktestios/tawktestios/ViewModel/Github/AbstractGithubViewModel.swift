//
//  AbstractGithubViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

protocol AbstractGithubViewModel: ViewModel {
    var githubUserList: [GithubUser] {get set}
    func getGithubUserList(page: Int) -> Observable<[GithubUser]>
    func getGithubUserList(since: Int, completeionHandler: @escaping (() -> Void))
}
