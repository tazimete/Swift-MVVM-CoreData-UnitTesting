//
//  GithubViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa
import RxFlow

class GithubViewModel: AbstractGithubViewModel {
    typealias T = GithubUserEntity
    public var githubUserList: [GithubUser] = [GithubUser]()
    public var paginationOffset = 0
    public var paginationlimit = 20
    
    public lazy var fetchedResultsController: NSFetchedResultsController<GithubUserEntity> = {
        let fetchRequest = NSFetchRequest<GithubUserEntity>(entityName:"GithubUserEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending:true)]
//        fetchRequest.fetchOffset = paginationOffset
//        fetchRequest.fetchLimit = paginationOffset + paginationlimit
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: CoreDataClient.shared.persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
//        controller.delegate = self
        fetchRequest.fetchBatchSize = paginationlimit
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    var steps = PublishRelay<Step>()
    var service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func getGithubUserList(since: Int, completeionHandler: @escaping (() -> Void)) {
        service.remoteDataSource.getGitubUserList(since: since) { [weak self] result in
            switch result{
                case .success(let users):
                    guard let weakSelf = self else {
                        return
                    }
                    print("getGithubUserList() -- \((users.last?.username)!)")
                    weakSelf.service.localDataSource.syncData(data: users, taskContext: (weakSelf.service.localDataSource.persistentContainer.newBackgroundContext()))
                    weakSelf.githubUserList.append(contentsOf: users)
                case .failure(let error):
                    print("\(String(describing: (error as? NetworkError)?.localizedDescription))")
            }
        }
    }
}
