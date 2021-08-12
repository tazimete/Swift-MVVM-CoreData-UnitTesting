//
//  UserProfileViewModel.swift
//  tawktestios
//
//  Created by JMC on 5/8/21.
//

import CoreData


/*
 This class will be used for fetching github user profile from its remote data source and update user data from local data source.
 As ViewModel accepts a service, server data model, and coredata model, we assign (As it will fetch github user info) GithubService, GithubUser (AbstractDataModel & codable) and GithubUserEntity respectively for creating UserProfileViewModel
 */

public class UserProfileViewModel: ViewModel<GithubService, GithubUser, GithubUserEntity> {

    public override init(with service: GithubService) {
        super.init(with: service)
    }
    
    public func fetchProfile(username: String) {
        service.remoteDataSource.fetchData(request: .fetchUserProfile(params: FetchUserProfileParam(username: username))) { [weak self] result in
            
            guard let weakSelf = self else {
                return
            }

            switch result{
                case .success(let user):
                    weakSelf.data = user
                    weakSelf.dataFetchingSuccessHandler?()
                case .failure(let error):
                    print("\(String(describing: (error).localizedDescription))")
                    weakSelf.errorMessage = (String(describing: (error).localizedDescription)) 
                    weakSelf.dataFetchingFailedHandler?()
            }
        }
    }
    
    public func updateUserEntity(user: GithubUserEntity) {
        service.localDataSource.updateItem(item: user, taskContext: CoreDataClient.shared.backgroundContext)
    }
}
