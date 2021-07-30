//
//  DataProvider.swift
//  tawktestios
//
//  Created by JMC on 29/7/21.
//

import CoreData

//let dataErrorDomain = "dataErrorDomain"

//class ApiRepository {
//
//}

//enum DataErrorCode: NSInteger {
//    case networkUnavailable = 101
//    case wrongDataFormat = 102
//}

class DataProvider {
    
    public let persistentContainer: NSPersistentContainer
//    private let repository: ApiRepository
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
//        self.repository = repository
    }
    
//    func fetchFilms(completion: @escaping(Error?) -> Void) {
//        repository.getFilms() { jsonDictionary, error in
//            if let error = error {
//                completion(error)
//                return
//            }
//
//            guard let jsonDictionary = jsonDictionary else {
//                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
//                completion(error)
//                return
//            }
//
//            let taskContext = self.persistentContainer.newBackgroundContext()
//            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//            taskContext.undoManager = nil
//
//            _ = self.syncFilms(jsonDictionary: jsonDictionary, taskContext: taskContext)
//
//            completion(nil)
//        }
//    }
    
    public func syncGithubUserList(githubUsers: [GithubUser], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        
        taskContext.performAndWait {
            let userIds = githubUsers.map { $0.id ?? -1 }.compactMap { $0 }
            //delete old matched data to get latest and updated data from server
            batchDeleteItems(userIds: userIds, taskContext: taskContext)
            
//            let matchingRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GithubUserEntity")
//             let userIds = githubUsers.map { $0.id ?? -1 }.compactMap { $0 }
//            matchingRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [userIds])
            
//            //delete old matched data to get latest and updated data from server
//            batchDeleteItems(userIds: userIds, taskContext: taskContext)
//            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingRequest)
//            batchDeleteRequest.resultType = .resultTypeObjectIDs
//
//            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
//            do {
//                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
//
//                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
//                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
//                                                        into: [self.viewContext])
//                }
//            }catch {
//                print("Error: \(error)\nCould not batch delete existing records.")
//                return
//            }
            
            // Create new records.
//            for githubUser in githubUsers {
//
//                guard let userEntity = NSEntityDescription.insertNewObject(forEntityName: "GithubUserEntity", into: taskContext) as? GithubUserEntity else {
//                    print("Error: Failed to create a new user object!")
//                    return
//                }
//
//                do {
//                    try userEntity.update(user: githubUser)
//                } catch {
//                    print("Error: \(error)\n this object will be deleted.")
//                    taskContext.delete(userEntity)
//                }
//            }
            
            insertItemsToStore(items: githubUsers, taskContext: taskContext)
            
            // Save all the changes just made and reset the taskContext to free the cache.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successfull = true
        }
        return successfull
    }
    
    
    // /delete old matched data to get latest and updated data from server
    public func batchDeleteItems(userIds: [Int], taskContext: NSManagedObjectContext){
        let matchingRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GithubUserEntity")
        matchingRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [userIds])
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
        do {
            let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
            
            if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                    into: [self.viewContext])
            }
        }catch {
            print("Error: \(error)\nCould not batch delete existing records.")
        }
    }
    
    //insert item to store
    public func insertItemsToStore(items: [GithubUser], taskContext: NSManagedObjectContext) {
        for githubUser in items {
            
            guard let userEntity = NSEntityDescription.insertNewObject(forEntityName: "GithubUserEntity", into: taskContext) as? GithubUserEntity else {
                print("Error: Failed to create a new user object!")
                return
            }
            
            do {
                try userEntity.update(user: githubUser)
            } catch {
                print("Error: \(error)\n this object will be deleted.")
                taskContext.delete(userEntity)
            }
        }
    }
}
