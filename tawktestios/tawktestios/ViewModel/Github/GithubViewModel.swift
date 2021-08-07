//
//  GithubViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData

public class GithubViewModel: ViewModel<GithubService, GithubUser, GithubUserEntity> {

    public override init(with service: GithubService) {
        super.init(with: service)
    }
    
    public override func fetchDataList(page: Int, completionHandler: @escaping NetworkCompletionHandler<[GithubUser]>) {
        service.remoteDataSource.fetchDataList(request: .fetchUserList(params: FetchGithubUserParam(since: page)), completionHandler: completionHandler)
    }
    
    public func fetchUserList(since: Int) {
        fetchDataList(page: since) { [weak self] result in
            guard let weakSelf = self else {
                return
            }

            switch result{
                case .success(let users):
                    print("fetchData() -- \(users.map({$0.username}))")
                    weakSelf.service.localDataSource.syncData(data: users, taskContext: CoreDataClient.shared.mainContext)
//                    weakSelf.dataList.append(contentsOf: users)

                    weakSelf.dataFetchingSuccessHandler?()
                case .failure(let error):
                    print("\(String(describing: (error).localizedDescription))")
                    weakSelf.errorMessage = (String(describing: (error).localizedDescription)) 
                    weakSelf.dataFetchingFailedHandler?()
            }
        }
    }
    
    public func searchUser(searchText: String) {
//        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
//        let pred1: NSPredicate = NSPredicate(format: "username CONTAINS[c] %@", text)
//        let pred2: NSPredicate = NSPredicate(format: "username == %@", text)
//        let pred3: NSPredicate = NSPredicate(format: "note CONTAINS[c] %@", text)
//        let pred4: NSPredicate = NSPredicate(format: "note == %@", text)
//
//        var predicates:NSPredicate? = NSCompoundPredicate(orPredicateWithSubpredicates:[pred1,pred2, pred3, pred4])
//
//        if searchText.isEmpty {
//            predicates = nil
//        }
        
//        fetchedResultsController.fetchRequest.predicate = predicates
//        try? fetchedResultsController.performFetch()
//
//        fetchedResultsController.managedObjectContext.refreshAllObjects()
        
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let params = ["username": text, "note": text]
        service.localDataSource.search(params: params, controller: fetchedResultsController, isEnded: text.isEmpty)
    }
    
    public func clearSearch() {
//        fetchedResultsController.fetchRequest.predicate = nil
//        try? fetchedResultsController.performFetch()
//
//        fetchedResultsController.managedObjectContext.refreshAllObjects()
        service.localDataSource.clearSearch(controller: fetchedResultsController)
    }
}
