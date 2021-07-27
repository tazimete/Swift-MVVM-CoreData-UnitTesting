//
//  GithubViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

class GithubViewModel: AbstractGithubViewModel, InputOutputType {
    struct Input {
        let fetchGithubUserList: Observable<Void>
    }
    
    struct Output {
        let githubUserList: BehaviorRelay<[GithubUser]>
    }
    
    var steps = PublishRelay<Step>()
    var service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func transform(input: Input) -> Output {
        let githubUserList = BehaviorRelay<[GithubUser]>(value: [])
        
        input.fetchGithubUserList.flatMapLatest({() -> Observable<[GithubUser]> in
            return self.getGithubUserList(page: 20)
        }).subscribe(onNext: {
            [unowned self] userList in
            print("\(self) -- transform() -- user name = \(userList.last?.username ?? "")")
            githubUserList.accept(userList)
        },onError: nil, onCompleted: nil, onDisposed: nil)
        
        return Output(githubUserList: githubUserList)
    }
    
    func getGithubUserList(page: Int) -> Observable<[GithubUser]> {
        return service.remoteDataSource.getGithubUserList(page: 20)
    }
    
    func getGithubUserList(since: Int) {
        service.remoteDataSource.getGitubUserList(since: 20) { result in
            switch result{
                case .success(let users):
                    print("getGithubUserList() -- \(users.last?.username)")
                
                case .failure(let error):
                    print("\((error as? NetworkError)?.localizedDescription)")
            }
        }
    }
}
