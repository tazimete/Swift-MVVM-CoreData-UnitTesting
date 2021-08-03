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


public class ViewModel<S: Service, D: AbstractDataModel & Codable, T: NSManagedObject>: AbstractViewModel {
    public typealias S = S
    public typealias D = D
    public typealias T = T
    
    public var steps = PublishRelay<Step>()
    
    public var service: S
    
    public var paginationOffset: Int = 0
    
    public var paginationlimit: Int = 20
    
    public var dataFetchingSuccessHandler: (() -> Void)?
    public var dataFetchingFailedHandler: (() -> Void)?
    
    public lazy var fetchedResultsController: NSFetchedResultsController<T> = {
        let fetchRequest = NSFetchRequest<T>(entityName: CoreDataEntities<T>.getEntityName())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending:true)]
        fetchRequest.fetchOffset = paginationOffset
        fetchRequest.fetchLimit = paginationOffset + paginationlimit
        fetchRequest.fetchBatchSize = paginationlimit
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: CoreDataClient.shared.mainContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self.fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    weak public var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    public var dataList: [D] = []
    public var errorMessage: String = "Failed to fetch data..."
    
    public init(with service: S){
        self.service = service
    }
    
    public func setPaginationOffset(offset: Int) {
        paginationOffset = offset
    }
    
    public func setPaginationLimit(limit: Int) {
        paginationlimit = limit
    }
    
    func fetchData(page: Int, completionHandler: @escaping NetworkCompletionHandler<D>) {
        fatalError("Must be overwitten")
    }
    
    func fetchDataList(page: Int, completionHandler: @escaping NetworkCompletionHandler<[D]>) {
        fatalError("Must be overwitten")
    }
}
