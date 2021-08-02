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

public class GithubViewModel: ViewModel<GithubService, GithubUser, GithubUserEntity> {

    public override init(with service: GithubService) {
        super.init(with: service)
    }
    
    public override func fetchDataList(page: Int, completionHandler: @escaping NetworkCompletionHandler<[GithubUser]>) {
        service.remoteDataSource.fetchDataList(request: .fetchUserList(params: FetchGithubUserParams(since: page)), completionHandler: completionHandler)
    }
    
    public func fetchDataList(since: Int) {
        fetchDataList(page: since) { [weak self] result in
            guard let weakSelf = self else {
                return
            }

            switch result{
                case .success(let users):
                    print("fetchData() -- \(users.map({$0.username}))")
                    weakSelf.service.localDataSource.syncData(data: users, taskContext: CoreDataClient.shared.backgroundContext)
//                    weakSelf.dataList.append(contentsOf: users)

                    weakSelf.dataFetchingSuccessHandler?()
                case .failure(let error):
                    print("\(String(describing: (error).localizedDescription))")
                    weakSelf.dataFetchingFailedHandler?()
            }
        }
    }
}
