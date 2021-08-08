//
//  GithubViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData

public class GithubViewModel: ViewModel<GithubService, GithubUser, GithubUserEntity> {

    public override init(with service: GithubService) {
        super.init(with: service)
    }
    
    public override func fetchDataList(page: Int, completionHandler: @escaping NetworkCompletionHandler<[GithubUser]>) {
        service.remoteDataSource.fetchDataList(request: .fetchUserList(params: FetchGithubUserParam(since: page)), completionHandler: completionHandler)
    }
    
    public func fetchUserList(since: Int) {
        fetchDataList(page: since) { [weak self] result in
            guard let weakSelf = self else {
                return
            }

            switch result{
                case .success(let users):
                    print("fetchData() -- \(users.map({$0.username}))")
                    weakSelf.service.localDataSource.syncData(data: users, taskContext: CoreDataClient.shared.mainContext)
//                    weakSelf.dataList.append(contentsOf: users)

                    weakSelf.dataFetchingSuccessHandler?()
                case .failure(let error):
                    print("\(String(describing: (error).localizedDescription))")
                    weakSelf.errorMessage = (String(describing: (error).localizedDescription)) 
                    weakSelf.dataFetchingFailedHandler?()
            }
        }
    }
    
    public func searchUser(searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let params = ["username": text, "note": text]
        service.localDataSource.search(params: params, controller: fetchedResultsController, isEnded: text.isEmpty)
    }
    
    public func clearSearch() {
        service.localDataSource.clearSearch(controller: fetchedResultsController)
    }
}
