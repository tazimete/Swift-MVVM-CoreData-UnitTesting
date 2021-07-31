//
//  AbstractDataSource.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData

protocol RemoteDataSource: AnyObject {
    var apiClient: APIClient {set get}
    
    func getGitubUserList(since: Int, completionHandler: @escaping NetworkCompletionHandler<[GithubUser]>)
}


protocol LocalDataSource: AnyObject {
//    associatedtype T: AbstractDataModel
    var persistentContainer: NSPersistentContainer {get set}
    var viewContext: NSManagedObjectContext {get set}
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {get set}
    var entityName: String {get}
    
    func insertEntity(entityName: String, into: NSManagedObjectContext) -> NSManagedObject?
    func syncData<T: AbstractDataModel>(data: [T], taskContext: NSManagedObjectContext) -> Bool
    func batchDeleteItems(ids: [Int], taskContext: NSManagedObjectContext)
    func insertItemsToStore<T: AbstractDataModel>(items: [T], taskContext: NSManagedObjectContext)
}
