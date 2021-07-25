//
//  GithubFlow.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import RxSwift
import RxFlow


final class GithubFlow: Flow {
    private let githubLocalDataSource: DataSource
    private let githubRemoteDataSource: DataSource
    
    var root: Presentable {
        rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        return UINavigationController()
    }()
    
    init() {
        self.githubLocalDataSource = GithubLocalDataSource()
        self.githubRemoteDataSource = GithubRemoteDataSource()
    }
    
    deinit {
        print("Deinit")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = transform(step: step) as? GithubStep else {
            return .none
        }
        switch step {
        case .userList:
            return showGithubUserListViewController()
        case .userProfile:
            return showGithubUserListViewController()
        case .dismiss:
            return dismissChildFlow()
        }
    }
    
    private func transform(step: Step) -> Step? {
        return GithubStep.userList
    }
}

private extension GithubFlow {
    func showGithubUserListViewController() -> FlowContributors {
        let service = GithubService(localDataSource: githubLocalDataSource, remoteDataSource: githubRemoteDataSource)
        let viewModel = GithubViewModel(service: service)
        let viewController = GithubUserListViewController.loadViewController(viewModel: viewModel)
        rootViewController.setViewControllers([viewController as! UIViewController], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController as! Presentable, withNextStepper: viewModel as! Stepper))
    }
    
    func dismissChildFlow() -> FlowContributors {
        rootViewController.presentedViewController?.dismiss(animated: true, completion: nil)
        return .none
    }
}
