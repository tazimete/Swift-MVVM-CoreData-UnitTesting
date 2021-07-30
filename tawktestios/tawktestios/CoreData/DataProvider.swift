//
//  DataProvider.swift
//  tawktestios
//
//  Created by JMC on 29/7/21.
//

import CoreData

protocol LocalDataSource: AnyObject {
    associatedtype T
    var persistentContainer: NSPersistentContainer {get set}
    var viewContext: NSManagedObjectContext {get set}
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {get set}
    
    func insertEntity(entityName: String, into: NSManagedObjectContext) -> NSManagedObject?
    func syncData<T: AbstractDataModel>(data: [T], taskContext: NSManagedObjectContext) -> Bool
    func batchDeleteItems(ids: [Int], taskContext: NSManagedObjectContext)
    func insertItemsToStore<T: AbstractDataModel>(items: [T], taskContext: NSManagedObjectContext)
}

class DataProvider : LocalDataSource{
    typealias T = GithubUser
    
    public var persistentContainer: NSPersistentContainer
    public var viewContext: NSManagedObjectContext
//    {
//        return persistentContainer.viewContext
//    }
    var fetchRequest: NSFetchRequest<NSFetchRequestResult>
//    var entity: NSManagedObject
    
    public init(persistentContainer: NSPersistentContainer, viewContext: NSManagedObjectContext) {
        self.persistentContainer = persistentContainer
        self.viewContext = viewContext
        self.fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GithubUserEntity") 
//        self.entity = NSEntityDescription.insertNewObject(forEntityName: "GithubUserEntity", into: self.viewContext) as! GithubUserEntity
    }
    
//    public func makeFetchRequest(entityName: String) -> NSFetchRequest<NSFetchRequestResult> {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName) // GithubUserEntity
//        return fetchRequest
//    }
    
    public func insertEntity(entityName: String, into: NSManagedObjectContext) -> NSManagedObject? {
        return NSEntityDescription.insertNewObject(forEntityName: "GithubUserEntity", into: into)
    }
    
    public func syncData<T>(data: [T], taskContext: NSManagedObjectContext) -> Bool where T : AbstractDataModel {
        var successfull = false

        taskContext.performAndWait {
            let userIds = data.map { $0.id ?? -1 }.compactMap { $0 }

            //delete old matched data to get latest and updated data from server
            batchDeleteItems(ids: userIds, taskContext: taskContext)

            // Create new records.
            insertItemsToStore(items: data, taskContext: taskContext)

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
    
    public func batchDeleteItems(ids: [Int], taskContext: NSManagedObjectContext) {
//        let matchingRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GithubUserEntity")
//        let matchingRequest = makeFetchRequest(entityName: "GithubUserEntity")
        fetchRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [ids])

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
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
    
    public func insertItemsToStore<T>(items: [T], taskContext: NSManagedObjectContext) where T : AbstractDataModel {
        for item in items {

//            guard let userEntity = NSEntityDescription.insertNewObject(forEntityName: "GithubUserEntity", into: taskContext) as? GithubUserEntity else {
            guard let userEntity = insertEntity(entityName: "GithubUserEntity", into: taskContext) as? GithubUserEntity else {
                print("Error: Failed to create a new user object!")
                return
            }

            do {
                try userEntity.update(user: item)
            } catch {
                print("Error: \(error)\n this object will be deleted.")
                taskContext.delete(userEntity)
            }
        }
    }
    
    
//    public func syncGithubUserList(githubUsers: [GithubUser], taskContext: NSManagedObjectContext) -> Bool {
//        var successfull = false
//
//        taskContext.performAndWait {
//            let userIds = githubUsers.map { $0.id ?? -1 }.compactMap { $0 }
//
//            //delete old matched data to get latest and updated data from server
//            batchDeleteItems(userIds: userIds, taskContext: taskContext)
//
//            // Create new records.
//            insertItemsToStore(items: githubUsers, taskContext: taskContext)
//
//            // Save all the changes just made and reset the taskContext to free the cache.
//            if taskContext.hasChanges {
//                do {
//                    try taskContext.save()
//                } catch {
//                    print("Error: \(error)\nCould not save Core Data context.")
//                }
//                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
//            }
//            successfull = true
//        }
//        return successfull
//    }
    
    
    // /delete old matched data to get latest and updated data from server
//    public func batchDeleteItems(userIds: [Int], taskContext: NSManagedObjectContext){
//        let matchingRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GithubUserEntity")
//        matchingRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [userIds])
//
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingRequest)
//        batchDeleteRequest.resultType = .resultTypeObjectIDs
//
//        // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
//        do {
//            let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
//
//            if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
//                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
//                                                    into: [self.viewContext])
//            }
//        }catch {
//            print("Error: \(error)\nCould not batch delete existing records.")
//        }
//    }
    
    //insert item to store
//    public func insertItemsToStore(items: [GithubUser], taskContext: NSManagedObjectContext) {
//        for githubUser in items {
//
//            guard let userEntity = NSEntityDescription.insertNewObject(forEntityName: "GithubUserEntity", into: taskContext) as? GithubUserEntity else {
//                print("Error: Failed to create a new user object!")
//                return
//            }
//
//            do {
//                try userEntity.update(user: githubUser)
//            } catch {
//                print("Error: \(error)\n this object will be deleted.")
//                taskContext.delete(userEntity)
//            }
//        }
//    }
}
