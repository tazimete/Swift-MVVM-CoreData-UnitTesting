//
//  GithubViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData

/*
 This class will be used for fetching github user list from its remote data source and search users from local data source.
 As ViewModel accepts a service, server data model, and coredata model, we assign GithubService, GithubUser (AbstractDataModel & codable) and GithubUserEntity respectively for creating GithubViewModel 
 */

public class GithubViewModel: ViewModel<GithubService, GithubUser, GithubUserEntity> {

    public override init(with service: GithubService) {
        super.init(with: service)
    }
    
    public override func fetchDataList(params: Parameterizable, completionHandler: @escaping NetworkCompletionHandler<[GithubUser]>) {
        service.remoteDataSource.fetchDataList(request: .fetchUserList(params: params), completionHandler: completionHandler)
    }
    
    public func fetchUserList(since: Int) {
        fetchDataList(params: FetchGithubUserParam(since: since, perPage: 30)) { [weak self] result in
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
