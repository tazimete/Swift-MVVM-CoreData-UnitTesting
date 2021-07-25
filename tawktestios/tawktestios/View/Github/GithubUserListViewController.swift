//
//  ViewController.swift
//  tawktestios
//
//  Created by JMC on 23/7/21.
//

import UIKit
import RxSwift
import RxCocoa

class GithubUserListViewController: BaseViewController {
    
    public static func loadViewController(viewModel: ViewModel) -> GithubUserListViewController?{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GithubUserListViewController") as! GithubUserListViewController
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        APIClient.shared.send(apiRequest: GithubApiRequest.fetchUserList(params: FetchGithubUserParams(since: 20)), type: [GithubUser].self)
//            .subscribe(onNext: { user in
//                print("user list = \(user.last?.username ?? "")")
//        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel as? GithubViewModel else {
            return
        }
        
        let output = viewModel.transform(input: GithubViewModel.Input(fetchGithubUserList: Observable.just(())))
        
        output.githubUserList.asDriver().drive(UITableView().rx.items(cellIdentifier: "R.reuseIdentifier.repoViewCell", cellType: UITableViewCell.self)) { tableView, viewModel, cell in
//            cell.bind(to: viewModel)
        }.dispose()
//            .subscribe(onNext: {
//                [unowned self] user in
//                print("\(self.description) -- bindViewModel() -- user list = \(user.last?.username ?? "")")
//        },onError: nil, onCompleted: nil, onDisposed: nil)
    }
}

