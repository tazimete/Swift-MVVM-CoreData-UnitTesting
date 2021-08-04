//
//  RootCoordinator.swift
//  tawktestios
//
//  Created by JMC on 31/7/21.
//

import UIKit


class RootCoordinator: Coordinator {
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
}
