//
//  AbstractDataSource.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData

/*
 This is the abstraction of our Remote data source of our project, It uses generic data model to fetch certain request
 and write response data to certain model. Request must be type of APIRequest and Data model must be conformed from AbstractDataModel
 */
public protocol AbstractRemoteDataSource: AnyObject {
    associatedtype T: APIRequest
    associatedtype D: AbstractDataModel & Codable
    var apiClient: AbstractApiClient {set get}
    
    func fetchData(request: T, completionHandler: @escaping NetworkCompletionHandler<D>)
    func fetchDataList(request: T, completionHandler: @escaping NetworkCompletionHandler<[D]>)
}


/*
 This is the abstraction of our local data source of our project, It uses generic data model (AbstractDataModel/NSManagedObject ) to store and retrieve data which is actually server response, must be conformed from AbstractdataModel.
  Write response data to NSManagedObject model, which is coredata model.
 */
public protocol AbstractLocalDataSource: AnyObject {
    associatedtype T: AbstractDataModel = AbstractDataModel
    associatedtype D: NSManagedObject = NSManagedObject
    
    var persistentContainer: NSPersistentContainer {get set}
    var viewContext: NSManagedObjectContext {get set}
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {get set}
    var entityName: String {get}
    
    func fetchItems(taskContext: NSManagedObjectContext)  ->[D]
    func fetchItems(ids: [Int], taskContext: NSManagedObjectContext) -> [D]
    func insertEntity(entityName: String, into: NSManagedObjectContext) -> D?
    func insertItems(items: [T], taskContext: NSManagedObjectContext)
    func batchDeleteItems(ids: [Int], taskContext: NSManagedObjectContext)
    func deleteAllItems(taskContext: NSManagedObjectContext)
    func syncData(data: [T], taskContext: NSManagedObjectContext) -> Bool
    func search(params: [String: String], controller: NSFetchedResultsController<D>, isEnded: Bool)
    func clearSearch(controller: NSFetchedResultsController<D>)
}

