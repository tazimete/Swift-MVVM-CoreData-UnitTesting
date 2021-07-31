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
    associatedtype T: NSManagedObject
    associatedtype D: AbstractDataModel
    
    var service: Service {get set}
    var paginationOffset: Int {get set}
    var paginationlimit: Int {get set}
    var dataFetchingCompleteionHandler: (() -> Void)? {get set}
    
    var fetchedResultsController: NSFetchedResultsController<T> {get set}
    var dataList: [D] {get set}
    func fetchData(since: Int)
    func setPaginationOffset(offset: Int)
    func setPaginationLimit(limit: Int)
}
