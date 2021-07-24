//
//  ViewController.swift
//  tawktestios
//
//  Created by JMC on 23/7/21.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        APIClient.shared.send(apiRequest: GithubApiRequest.fetchUserList(params: FetchGithubUserParams(since: 20)), type: [GithubUser].self)
//            .subscribe(onNext: { user in
//                print("user list = \(user.last?.username ?? "")")
//        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    override func bindViewModel() {
//        guard let viewModel = viewModel as? GithubViewModel else {
//            return
//        }
        
        GithubViewModel(service: GithubService(localDataSource: GithubLocalDataSource(), remoteDataSource: GithubRemoteDataSource())).service.remoteDataSource.getGithubUserList(page: 20)
            .subscribe(onNext: {
                [unowned self] user in
                print("\(self.TAG) -- bindViewModel() -- user list = \(user.last?.username ?? "")")
            },onError: nil, onCompleted: nil, onDisposed: nil)
    }
}

