//
//  ViewController.swift
//  tawktestios
//
//  Created by JMC on 23/7/21.
//

import UIKit
import CoreData

class GithubUserListViewController: BaseViewController<GithubService, GithubUser, GithubUserEntity>, Storyboarded  {
    private var githubViewModel: GithubViewModel!
    private let cellConfiguratorFactory = TableViewCellConfiguratorFactory()
    private let shimmerOffset = 10
    
    private let tableView = UITableView()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = .brown
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = true
        self.definesPresentationContext = true
        
        return searchController
    }()
    
    
    override public init(viewModel: ViewModel<S, D, T>) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        isShimmerNeeded = true
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func initView() {
        super.initView()
        //setup tableview
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0, enableInsets: true)
        
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        // tableview delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        //cell registration
        tableView.register(GithubUserCellNormal.self, forCellReuseIdentifier: GithubUserNormalCellConfig.reuseId)
        tableView.register(GithubUserCellNote.self, forCellReuseIdentifier: GithubUserNoteCellConfig.reuseId)
        tableView.register(GithubUserCellInverted.self, forCellReuseIdentifier: GithubUserInvertedCellConfig.reuseId)
        tableView.register(GithubUserShimmerCell.self, forCellReuseIdentifier: GithubUserShimmerCellConfig.reuseId)
        
        addBottomIndicator()
        
        //add serch controller
        self.navigationItem.titleView = self.searchController.searchBar
    }
    
    private func addBottomIndicator (){
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
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
        
        githubViewModel.fetchedResultsControllerDelegate = self 
        
        cellConfiguratorFactory.addAllAsCellConfigurator(cellViewModels: githubViewModel.fetchedResultsController.fetchedObjects?.map({ return $0.asCellViewModel}) ?? [])
        
        //load user list from server
        loadGithubUserList(since: githubViewModel.paginationlimit)
    }
    
    //when internet connected
    override func didReachabilityConnected() {
        //execute last request
        loadMoreData()
    }
    
    public func loadGithubUserList(since: Int) {
        showBottomIndicator(flag: true)
        
        // removed temporarily
//        cellConfiguratorFactory.addAllAsCellConfigurator(cellViewModels: githubViewModel.fetchedResultsController.fetchedObjects?.map({ return $0.asCellViewModel}) ?? [])
        
        isShimmerNeeded = cellConfiguratorFactory.getCount() == 0
        
        githubViewModel.fetchUserList(since: since)
        githubViewModel.dataFetchingSuccessHandler = { [weak self] in
            print("\(self?.TAG) -- dataFetchingSuccessHandler()")
            self?.stopShimmering()
        }
        
        githubViewModel.dataFetchingFailedHandler = {
            [weak self] in
            print("\(self?.TAG) -- dataFetchingFailedHandler()")
            self?.showBottomIndicator(flag: true)
        }
    }
    
    // stop shimmer effect when got data from server (First tiem only)
    private func stopShimmering() {
        if self.isShimmerNeeded {
            self.isShimmerNeeded = false
            tableView.reloadData()
        }
    }
    
    private func getLastUserEntity() -> GithubUserEntity? {
        return (githubViewModel.fetchedResultsController.fetchedObjects?.last)
    }
    
    private func getUserObjectAt(indexPath: IndexPath) -> GithubUser? {
        return (githubViewModel.fetchedResultsController.object(at: indexPath) as? GithubUserEntity)?.asGithubUser
    }
    
    private func getUserEntityAt(indexPath: IndexPath) -> GithubUserEntity? {
        return (githubViewModel.fetchedResultsController.object(at: indexPath) as? GithubUserEntity)
    }
    
    private func getReuseIdentifier(item: CellConfigurator) -> String {
        return type(of: item).reuseId
    }
    
    //MARK: Pagination
    //check if server has more data to load by pagination
    override func hasMoreData() -> Bool {
        return true
    }
    
    // load more data on paginate
    override func loadMoreData() -> Void {
        if isPaginationEnabled {
            //increase pagination offset
            githubViewModel.paginationOffset += githubViewModel.paginationlimit
            
            var userId = githubViewModel.paginationlimit
            
            if let user = getLastUserEntity()?.asGithubUser  {
                userId = user.id ?? 0
            }
            
            // api call to fetch github users from server
            loadGithubUserList(since: userId)
        }
    }
    
    // get last visible item of listview to calculate if pagination (data loading from server) needs or not
    override func getLastVisibleItem() -> IndexPath {
        guard let user = getLastUserEntity() else {
            return IndexPath(row: 0, section: 0)
        }
        
        guard let indexpath = githubViewModel.fetchedResultsController.indexPath(forObject: user) else{
            return IndexPath(row: 0, section: 0)
        }
        
        return indexpath
    }
    
    // total data count of from server to determine if scroll reached last item
    override func getTotalDataCount() -> Int {
        return githubViewModel.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    // limit of pagination offset to call pagination callback, after scrolling this limit, fetching data from server will be occured
    override func getPaginationOffset() -> Int {
        return githubViewModel.paginationlimit - 5
    }
}


// MARK: Tableview  
extension GithubUserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = githubViewModel.fetchedResultsController.fetchedObjects?.count ?? 0
//            count = githubViewModel.fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
        //load extra cell item for shimmer effect (it happens basically when fetchedResultsController.fetchedObjects = 0)
        if isShimmerNeeded {
            count += shimmerOffset
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: CellConfigurator = GithubUserShimmerCellConfig.init(item: GithubCellViewModel())
        
        if !isShimmerNeeded {
            // get cell configurator by cellviewmodel, which will bind cellviewmodel to the cell
            item = cellConfiguratorFactory.getCellConfigurator(cellViewModel: getUserEntityAt(indexPath: indexPath)?.asCellViewModel ?? GithubCellViewModel(), index: indexPath.row)!
        }

//        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: item).reuseId, for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: getReuseIdentifier(item: item), for: indexPath)
        item.configure(cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        view.endEditing(true)
        
        if isShimmerNeeded {
            return
        }
        
        guard let user = getUserEntityAt(indexPath: indexPath) else {
            return
        }
                                                
        //navigate to profile view controller 
        (self.view.window?.windowScene?.delegate as! SceneDelegate).rootCoordinator.showUserProfileController(user: user)
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

            // insert cell configurator to datasource/factory
            cellConfiguratorFactory.insertAsCellConfigurator(cellViewModel: getUserEntityAt(indexPath: index)?.asCellViewModel ?? GithubCellViewModel(), at: index.row)
            tableView.insertRows(at: [index], with: .automatic)

        case .delete:
            guard let index = indexPath else {
                return
            }

            // remove cell configurator from datasource/factory
            cellConfiguratorFactory.removeCellConfigurator(at: index.row)
            tableView.deleteRows(at: [index], with: .automatic)

        case .update:
            guard let index = indexPath else {
                return
            }
            
            // update cell configurator from datasource/factory
            cellConfiguratorFactory.updateAsCellConfigurator(cellViewModel: getUserEntityAt(indexPath: index)?.asCellViewModel ?? GithubCellViewModel(), at: index.row)
            tableView.reloadRows(at: [index], with: .automatic)

        case .move:
            guard let index = indexPath, let newIndex = indexPath else {
                return
            }

            // remove and insert cell configurator to datasource/factory 
            cellConfiguratorFactory.removeCellConfigurator(at: index.row)
            cellConfiguratorFactory.insertAsCellConfigurator(cellViewModel: getUserEntityAt(indexPath: newIndex)?.asCellViewModel ?? GithubCellViewModel(), at: newIndex.row)
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


//MARK: UISeacrController Delegate
extension GithubUserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //enable/disable pagination and bottom indicator
        if text.isEmpty {
            isPaginationEnabled = true
        }else{
            isPaginationEnabled = false
            showBottomIndicator(flag: false)
        }
        
        githubViewModel.searchUser(searchText: searchText)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isPaginationEnabled = true
        view.endEditing(true)
        githubViewModel.clearSearch()
        tableView.reloadData()
    }
}
