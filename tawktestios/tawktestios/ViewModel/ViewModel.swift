//
//  AbstractViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow
import CoreData


class ViewModel<T: NSManagedObject, D: AbstractDataModel>: AbstractViewModel {
    typealias T = T
    
    typealias D = D
    
    public var steps = PublishRelay<Step>()
    
    public var service: Service
    
    public var paginationOffset: Int = 0
    
    public var paginationlimit: Int = 20
    
    public var dataFetchingSuccessHandler: (() -> Void)?
    public var dataFetchingFailedHandler: (() -> Void)?
    
    public lazy var fetchedResultsController: NSFetchedResultsController<T> = {
        let fetchRequest = NSFetchRequest<T>(entityName: CoreDataEntities<T>.getEntityName())  // GithubUserEntity
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending:true)]
        fetchRequest.fetchOffset = paginationOffset
        fetchRequest.fetchLimit = paginationOffset + paginationlimit
        
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
    
    public var dataList: [D] = []
    public var errorMessage: String = "Failed to fetch data..."
    
    public init(with service: Service){
        self.service = service
    }
    
    public func setPaginationOffset(offset: Int) {
        paginationOffset = offset
    }
    
    public func setPaginationLimit(limit: Int) {
        paginationlimit = limit
    }
    
    public func fetchData(since: Int) {
        fatalError("Must be overwritten")
    }
}
