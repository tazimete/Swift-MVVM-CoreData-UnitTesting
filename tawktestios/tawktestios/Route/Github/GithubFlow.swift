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
    private let localDataSource: LocalDataSource<GithubUser, GithubUserEntity>
    private let remoteDataSource: RemoteDataSource<GithubApiRequest, GithubUser>
    
    var root: Presentable {
        rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        return UINavigationController()
    }()
    
    init() {
        self.localDataSource = LocalDataSource<GithubUser, GithubUserEntity>()
        self.remoteDataSource = RemoteDataSource<GithubApiRequest, GithubUser>() 
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
            return showUserProfileViewController()
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
        let service = GithubService(localDataSource: localDataSource, remoteDataSource: remoteDataSource)
        let viewModel = GithubViewModel(with: service)
        let viewController = GithubUserListViewController(viewModel: viewModel)
        rootViewController.setViewControllers([viewController as! UIViewController], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController as! Presentable, withNextStepper: viewModel as! Stepper))
    }
    
    func showUserProfileViewController() -> FlowContributors {
        let service = GithubService(localDataSource: localDataSource, remoteDataSource: remoteDataSource)
        let viewModel = UserProfileViewModel(with: service)
        let viewController = UserProfileViewController.instantiate(viewModel: viewModel)
        rootViewController.setViewControllers([viewController as! UIViewController], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController as! Presentable, withNextStepper: viewModel as! Stepper))
    }
    
    func dismissChildFlow() -> FlowContributors {
        rootViewController.presentedViewController?.dismiss(animated: true, completion: nil)
        return .none
    }
}
