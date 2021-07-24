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
    func getGithubUserList(page: Int) -> Observable<[GithubUser]>
}
