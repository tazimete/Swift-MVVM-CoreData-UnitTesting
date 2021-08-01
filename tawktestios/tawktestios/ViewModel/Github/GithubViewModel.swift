//
//  GithubViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa
import RxFlow

class GithubViewModel: ViewModel<GithubUserEntity, GithubUser> {

    override init(with service: Service) {
        super.init(with: service)
    }
    
    override func fetchData(since: Int) {
        service.remoteDataSource.getGitubUserList(since: since) { [weak self] result in
            guard let weakSelf = self else {
                return
            }
            
            switch result{
                case .success(let users):
                    print("fetchData() -- \(users.map({$0.username}))")
                    let isSuccess = weakSelf.service.localDataSource.syncData(data: users, taskContext: CoreDataClient.shared.backgroundContext)
//                    weakSelf.dataList.append(contentsOf: users)
                    
                    weakSelf.dataFetchingSuccessHandler?()
                case .failure(let error):
                    print("\(String(describing: (error).localizedDescription))")
                    weakSelf.dataFetchingFailedHandler?()
            }
        }
    }
}
