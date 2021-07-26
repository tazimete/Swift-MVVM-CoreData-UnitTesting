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
    private let tableView = UITableView()
    
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
    
    override func initView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.register(GithubUserCell.self, forCellReuseIdentifier: GithubUserCell.self.description())
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    override func bindViewModel() {
        guard let viewModel = viewModel as? GithubViewModel else {
            return
        }
        
        let output = viewModel.transform(input: GithubViewModel.Input(fetchGithubUserList: Observable.just(())))
        
        output.githubUserList
//            .asObservable()
//            .bind(to: tableView.rx.items) { (tableView, row, element) in
//                let indexPath = IndexPath(row: row, section: 0)
//                print("\(self.TAG) -- CustomTableViewCell -- item = \(element.username)")
//
//                let cell = tableView.dequeueReusableCell(withIdentifier: GithubUserCell.self.description(), for: indexPath) as! GithubUserCell    // 2
//                // Configure the cell
//                cell.user = element
////                cell.contentView.backgroundColor = .brown
//                return cell    // 3
//
//            }
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: GithubUserCell.self.description(), cellType: GithubUserCell.self)) { tableView, item, cell in
                cell.user = item
            }
        
        tableView.rx
            .modelSelected(GithubUser.self)
          .subscribe(onNext: { model in
            print("\(model.username) was selected")
          })
        
//        tableView.rx.b
    }
}
