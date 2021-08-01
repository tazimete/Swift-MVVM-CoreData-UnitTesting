//
//  ViewController.swift
//  tawktestios
//
//  Created by JMC on 23/7/21.
//

import UIKit
import CoreData

class GithubUserListViewController: BaseViewController<GithubUserEntity, GithubUser>, Storyboarded  {
    private let tableView = UITableView()
    private var githubViewModel: GithubViewModel!
    
    public static func loadViewController(viewModel: ViewModel<T,D>) -> GithubUserListViewController?{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GithubUserListViewController") as! GithubUserListViewController
        vc.viewModel = viewModel
        return vc
    }
    
    public static func instantiate(viewModel: ViewModel<T,D>) -> Self {
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
        
        addBottomIndicator()
        showBottomIndicator(flag: false)
    }
    
    private func addBottomIndicator (){
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        spinner.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        self.tableView.tableFooterView = spinner
    }
    
    private func showBottomIndicator(flag: Bool){
        self.tableView.tableFooterView?.isHidden = !flag
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
        showBottomIndicator(flag: true)
        githubViewModel.fetchData(since: since)
        githubViewModel.dataFetchingSuccessHandler = { [weak self] in
            print("\(self?.TAG) -- dataFetchingSuccessHandler()")
            self?.showBottomIndicator(flag: false)
        }
        
        githubViewModel.dataFetchingFailedHandler = {
            [weak self] in
            print("\(self?.TAG) -- dataFetchingFailedHandler()")
            self?.showBottomIndicator(flag: false)
        }
    }
    
    private func getLastUserEntity() -> GithubUserEntity?{
         return (githubViewModel.fetchedResultsController.fetchedObjects?.last)
    }
    
    private func getUserObjectAt(indexPath: IndexPath) -> GithubUser?{
         return (githubViewModel.fetchedResultsController.object(at: indexPath) as? GithubUserEntity)?.asGithubUser
    }
    
    //MARK: Pagination
    override func hasMoreData() -> Bool{
        return true
    }
    
    override func loadMoreData() -> Void{
        githubViewModel.paginationOffset += githubViewModel.paginationlimit
        
        guard let user = getLastUserEntity()?.asGithubUser else {
            return
        }
        
        loadGithubUserList(since: user.id ?? 0)
    }
    
    override func getLastVisibleItem() -> IndexPath{
        guard let user = getLastUserEntity() else {
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
        
        cell.user = getUserObjectAt(indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: NSFetchedResultsControllerDelegate
extension GithubUserListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      
        switch type {
          case .insert:
            guard let index = newIndexPath else {
                return
            }
            
            tableView.insertRows(at: [index], with: .automatic)
            
          case .delete:
            guard let index = indexPath else {
                return
            }
            
            tableView.deleteRows(at: [index], with: .automatic)
            
          case .update:
            guard let index = indexPath else {
                return
            }
            
            let cell = tableView.cellForRow(at: index) as! GithubUserCell
            cell.user = getUserObjectAt(indexPath: index)
            
          case .move:
            guard let index = indexPath, let newIndex = indexPath else {
                return
            }
            
            tableView.deleteRows(at: [index], with: .automatic)
            tableView.insertRows(at: [newIndex], with: .automatic)
            
          @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
          }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
