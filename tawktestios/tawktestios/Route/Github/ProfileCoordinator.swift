//
//  ProfileCoordinator.swift
//  tawktestios
//
//  Created by JMC on 31/7/21.
//

import UIKit


class ProfileCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let service = GithubService(localDataSource: GithubLocalDataSource(), remoteDataSource: GithubRemoteDataSource())
        let viewModel = GithubViewModel(with: service)
        let vc = GithubUserListViewController.instantiate(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
    }
}
