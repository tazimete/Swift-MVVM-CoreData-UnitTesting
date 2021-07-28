//
//  ViewController.swift
//  tawktestios
//
//  Created by JMC on 23/7/21.
//

import UIKit

class GithubUserListViewController: BaseViewController {
    private let tableView = UITableView()
    private var githubViewModel: AbstractGithubViewModel!
    
    public static func loadViewController(viewModel: ViewModel) -> GithubUserListViewController?{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GithubUserListViewController") as! GithubUserListViewController
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        testNetworkOperation()
    }
    
    override func initView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0, enableInsets: true)
        
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(GithubUserCell.self, forCellReuseIdentifier: GithubUserCell.cellReuseIdentifier)
    }
    
    override func bindViewModel() {
        githubViewModel = viewModel as! GithubViewModel
        
        githubViewModel.getGithubUserList(since: 20, completeionHandler: { [weak self] in
            self?.tableView.reloadData()
            print("\(self?.TAG) -- getGithubUserList() -- 0")
        })
        
        githubViewModel.getGithubUserList(since: 20, completeionHandler: { [weak self] in
            self?.tableView.reloadData()
            print("\(self?.TAG) -- getGithubUserList() -- 1")
        })
        
        githubViewModel.getGithubUserList(since: 20, completeionHandler: { [weak self] in
            self?.tableView.reloadData()
            print("\(self?.TAG) -- getGithubUserList() -- 2")
        })
        
        githubViewModel.getGithubUserList(since: 20, completeionHandler: { [weak self] in
            self?.tableView.reloadData()
            print("\(self?.TAG) -- getGithubUserList() -- 3")
        })
        
        githubViewModel.getGithubUserList(since: 20, completeionHandler: { [weak self] in
            self?.tableView.reloadData()
            print("\(self?.TAG) -- getGithubUserList() -- 4")
        })
    
    }
}


// MARK: Tableview  
extension GithubUserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        githubViewModel.githubUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GithubUserCell.cellReuseIdentifier, for: indexPath)
                as? GithubUserCell else{
            return UITableViewCell() 
        }
        
        cell.user = githubViewModel.githubUserList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        githubViewModel.getGithubUserList(since: 20, completeionHandler: { [weak self] in
            self?.tableView.reloadData()
            print("\(self?.TAG) -- getGithubUserList() -- 00")
        })
        
        githubViewModel.getGithubUserList(since: 20, completeionHandler: { [weak self] in
            self?.tableView.reloadData()
            print("\(self?.TAG) -- getGithubUserList() -- 11")
        })
        
        githubViewModel.getGithubUserList(since: 20, completeionHandler: { [weak self] in
            self?.tableView.reloadData()
            print("\(self?.TAG) -- getGithubUserList() -- 22")
        })
        
        githubViewModel.getGithubUserList(since: 20, completeionHandler: { [weak self] in
            self?.tableView.reloadData()
            print("\(self?.TAG) -- getGithubUserList() -- 33")
        })
        
        githubViewModel.getGithubUserList(since: 20, completeionHandler: { [weak self] in
            self?.tableView.reloadData()
            print("\(self?.TAG) -- getGithubUserList() -- 44")
        })
    }
}
