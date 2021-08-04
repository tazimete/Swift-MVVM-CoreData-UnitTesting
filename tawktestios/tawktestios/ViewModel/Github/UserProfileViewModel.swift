//
//  UserProfileViewModel.swift
//  tawktestios
//
//  Created by JMC on 5/8/21.
//


import CoreData

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
                    weakSelf.dataFetchingFailedHandler?()
            }
        }
    }
}
