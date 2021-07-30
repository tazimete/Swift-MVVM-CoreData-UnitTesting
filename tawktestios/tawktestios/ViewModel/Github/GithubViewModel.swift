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

class GithubViewModel: AbstractGithubViewModel {
//    public var dataProvider: DataProvider = DataProvider(persistentContainer: CoreDataClient.shared.persistentContainer, viewContext: CoreDataClient.shared.persistentContainer.viewContext, entityName: "GithubUserEntity")
    public var githubUserList: [GithubUser] = [GithubUser]()
    
    var steps = PublishRelay<Step>()
    var service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func getGithubUserList(since: Int, completeionHandler: @escaping (() -> Void)) {
        service.remoteDataSource.getGitubUserList(since: since) { [weak self] result in
            switch result{
                case .success(let users):
                    guard let weakSelf = self else {
                        return
                    }
                    print("getGithubUserList() -- \((users.last?.username)!)")
                    weakSelf.service.localDataSource.syncData(data: users, taskContext: (weakSelf.service.localDataSource.persistentContainer.newBackgroundContext()))
//                    syncGithubUserList(githubUsers: users, taskContext: (weakSelf.dataProvider.persistentContainer.newBackgroundContext()))
                    weakSelf.githubUserList.append(contentsOf: users)
//                    completeionHandler()
                case .failure(let error):
                    print("\(String(describing: (error as? NetworkError)?.localizedDescription))")
            }
        }
    }
}
