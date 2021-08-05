//
//  RootCoordinator.swift
//  tawktestios
//
//  Created by JMC on 31/7/21.
//

import UIKit

class GithubCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let service = GithubService(localDataSource: LocalDataSource<GithubUser, GithubUserEntity>(), remoteDataSource: RemoteDataSource<GithubApiRequest, GithubUser>())
        let viewModel = GithubViewModel(with: service)
        let vc = GithubUserListViewController.init(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showUserProfileController(user: GithubUserEntity) {
        let service = GithubService(localDataSource: LocalDataSource<GithubUser, GithubUserEntity>(), remoteDataSource: RemoteDataSource<GithubApiRequest, GithubUser>())
        let viewModel = UserProfileViewModel(with: service)
        let vc = UserProfileViewController.instantiate(viewModel: viewModel)
        vc.githubUser = user
        navigationController.pushViewController(vc, animated: false)
    }
}
