//
//  ViewController.swift
//  tawktestios
//
//  Created by JMC on 23/7/21.
//

import UIKit
import CoreData

class GithubUserListViewController: BaseViewController, Storyboarded  {
    private let tableView = UITableView()
    private var githubViewModel: GithubViewModel!
    
    public static func loadViewController(viewModel: ViewModel) -> GithubUserListViewController?{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GithubUserListViewController") as! GithubUserListViewController
        vc.viewModel = viewModel
        return vc
    }
    
    public static func instantiate(viewModel: ViewModel) -> Self {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GithubUserListViewController") as! GithubUserListViewController
        vc.viewModel = viewModel
        return vc as! Self
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
        
        githubViewModel.fetchedResultsController.delegate = self
        
        loadGithubUserList(since: githubViewModel.paginationlimit)
    }
    
    public func loadGithubUserList(since: Int){
//        do {
//            try githubViewModel.fetchedResultsController.performFetch()
//        }catch(let error){
//            print("\(TAG) -- loadGithubUserListOnPaginate() -- error = \(error)")
//        }
        
        githubViewModel.getGithubUserList(since: since, completeionHandler: { [weak self] in
            print("\(self?.TAG) -- getGithubUserList() -- since = \(since)")
        })
        
//        let user = (githubViewModel.fetchedResultsController.fetchedObjects?.last as? GithubUserEntity)?.asGithubUser
//        githubViewModel.getGithubUserList(since: user?.id ?? 0, completeionHandler: { [weak self] in
//            print("\(self?.TAG) -- loadGithubUserListOnPaginate() -- 00")
//        })
    }
    
    private func getLastEntity() -> GithubUserEntity?{
         return (githubViewModel.fetchedResultsController.fetchedObjects?.last)
    }
    
    //MARK: Pagination
    override func hasMoreData() -> Bool{
        return true
    }
    
    override func loadMoreData() -> Void{
        githubViewModel.paginationOffset += githubViewModel.paginationlimit
        
        guard let user = getLastEntity()?.asGithubUser else {
            return
        }
        
        loadGithubUserList(since: user.id ?? 0)
    }
    
    override func getLastVisibleItem() -> IndexPath{
        guard let user = getLastEntity() else {
            return IndexPath(row: 0, section: 0)
        }
        
        guard let indexpath = githubViewModel.fetchedResultsController.indexPath(forObject: user) else{
            return IndexPath(row: 0, section: 0)
        }
        
        return indexpath
    }
    
    override func getTotalDataCount() -> Int{
        return githubViewModel.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func getPaginationOffset() -> Int{
        return githubViewModel.paginationlimit - 5 
    }
}


// MARK: Tableview  
extension GithubUserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return githubViewModel.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GithubUserCell.cellReuseIdentifier, for: indexPath)
                as? GithubUserCell else{
            return UITableViewCell() 
        }
        
        cell.user = (githubViewModel.fetchedResultsController.object(at: indexPath) as? GithubUserEntity)?.asGithubUser
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


// MARK: NSFetchedResultsControllerDelegate 
extension GithubUserListViewController: NSFetchedResultsControllerDelegate {    
    func controllerWillChangeContent(_ controller:
      NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      
        switch type {
          case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
          case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
          case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! GithubUserCell
            cell.user = (githubViewModel.fetchedResultsController.object(at: indexPath!) as? GithubUserEntity)?.asGithubUser
          case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
          @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
          }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
