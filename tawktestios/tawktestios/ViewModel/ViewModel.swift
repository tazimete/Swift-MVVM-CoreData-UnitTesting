//
//  AbstractViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData


/*
 This is the base view model of our project. Which is will be used create all other view model of our porject. ViewModel consist generic service (S), server data model(D) and coredata model (T), means which data (conformed from AbstractDataModel & Codable) it should fetch from server and which core data entity (NSManagedObject type) it should store into local database through its service (Service has LocalDataSource and RemoteDataSource). ViewModel will fetch array of objects and single object  from server
 */

public class ViewModel<S: Service, D: AbstractDataModel & Codable, T: NSManagedObject>: AbstractViewModel {
    public typealias S = S
    public typealias D = D
    public typealias T = T
    
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
    
    public var data: D? 
    public var dataList: [D]? = []
    public var errorMessage: String?
    
    public init(with service: S){
        self.service = service
    }
    
    public func setPaginationOffset(offset: Int) {
        paginationOffset = offset
    }
    
    public func setPaginationLimit(limit: Int) {
        paginationlimit = limit
    }
    
    func fetchData(params: Parameterizable, completionHandler: @escaping NetworkCompletionHandler<D>) {
        fatalError("Must be overwitten")
    }
    
    func fetchDataList(params: Parameterizable, completionHandler: @escaping NetworkCompletionHandler<[D]>) {
        fatalError("Must be overwitten")
    }
}
