//
//  AbstractGithubViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData

/*
 This is the Abstraction of view model of our project. It will be used to ceate a base viewmodel, which is will be used create all other view model of our porject. AbstractViewModel consist generic service (S), server data model(D) and coredata model (T), means which data (conformed from AbstractDataModel & Codable) it should fetch from server and which core data entity (NSManagedObject type) it should store into local database through its service (Service has LocalDataSource and RemoteDataSource). It will fetch array of objects and single object  from server
 */

protocol AbstractViewModel {
    associatedtype S: Service
    associatedtype D: AbstractDataModel & Codable
    associatedtype T: NSManagedObject
    
    var service: S {get set}
    var paginationOffset: Int {get set}
    var paginationlimit: Int {get set}
    var dataFetchingSuccessHandler: (() -> Void)? {get set}
    var dataFetchingFailedHandler: (() -> Void)? {get set}
    
    var fetchedResultsController: NSFetchedResultsController<T> {get set}
    var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate? {set get}
    var data: D? {get set}
    var dataList: [D]? {get set}
    var errorMessage: String? {get set}
    
    func fetchData(params: Parameterizable, completionHandler: @escaping NetworkCompletionHandler<D>)
    func fetchDataList(params: Parameterizable, completionHandler: @escaping NetworkCompletionHandler<[D]>)
    func setPaginationOffset(offset: Int)
    func setPaginationLimit(limit: Int)
}
