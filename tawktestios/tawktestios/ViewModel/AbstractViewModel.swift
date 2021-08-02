//
//  AbstractGithubViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData
import RxFlow

protocol AbstractViewModel: Stepper {
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
    var dataList: [D] {get set}
    var errorMessage: String {get set}
    
    func fetchData(page: Int, completionHandler: @escaping NetworkCompletionHandler<D>)
    func fetchDataList(page: Int, completionHandler: @escaping NetworkCompletionHandler<[D]>)
    func setPaginationOffset(offset: Int)
    func setPaginationLimit(limit: Int)
}
