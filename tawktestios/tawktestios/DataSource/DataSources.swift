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
//    associatedtype D: NSManagedObject
    
    var persistentContainer: NSPersistentContainer {get set}
    var viewContext: NSManagedObjectContext {get set}
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {get set}
    var entityName: String {get}
    
    func fetchItems<T: NSManagedObject>(type: T, taskContext: NSManagedObjectContext)  ->[NSManagedObject]
    func insertEntity(entityName: String, into: NSManagedObjectContext) -> NSManagedObject?
    func insertItems<T: AbstractDataModel>(items: [T], taskContext: NSManagedObjectContext)
    func batchDeleteItems(ids: [Int], taskContext: NSManagedObjectContext)
    func syncData<T: AbstractDataModel>(data: [T], taskContext: NSManagedObjectContext) -> Bool
}


protocol AbstractRemoteDataSource: AnyObject {
    associatedtype T: APIRequest
    associatedtype D: AbstractDataModel
    var apiClient: APIClient {set get}
    
    func fetchData(since: Int, completionHandler: @escaping NetworkCompletionHandler<[GithubUser]>)
//    apiClient.enqueue(apiRequest: GithubApiRequest.fetchUserList(params: FetchGithubUserParams(since: since)), type: [GithubUser].self, completionHandler: completionHandler)
}

protocol AbstractLocalDataSource: AnyObject {
    associatedtype T: AbstractDataModel
    associatedtype D: NSManagedObject
    
    var persistentContainer: NSPersistentContainer {get set}
    var viewContext: NSManagedObjectContext {get set}
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {get set}
    var entityName: String {get}
    
    func fetchItems(taskContext: NSManagedObjectContext)  ->[D]
    func insertEntity(entityName: String, into: NSManagedObjectContext) -> D?
    func insertItems(items: [T], taskContext: NSManagedObjectContext)
    func batchDeleteItems(ids: [Int], taskContext: NSManagedObjectContext)
    func syncData(data: [T], taskContext: NSManagedObjectContext) -> Bool
}
