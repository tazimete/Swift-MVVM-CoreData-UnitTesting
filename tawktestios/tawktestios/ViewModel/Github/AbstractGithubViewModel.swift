//
//  AbstractGithubViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData

protocol AbstractGithubViewModel: ViewModel {
    associatedtype T:NSManagedObject
    
    var fetchedResultsController: NSFetchedResultsController<T> {get set}
    var githubUserList: [GithubUser] {get set}
    func getGithubUserList(since: Int, completeionHandler: @escaping (() -> Void))
}
