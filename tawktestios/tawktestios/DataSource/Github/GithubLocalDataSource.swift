//
//  DataProvider.swift
//  tawktestios
//
//  Created by JMC on 29/7/21.
//

import CoreData

class GithubLocalDataSource : LocalDataSource{
    typealias T = GithubUser
    
    public var persistentContainer: NSPersistentContainer
    public var viewContext: NSManagedObjectContext
    public lazy var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        let fRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        return fRequest
    }()
    
    public var entityName: String {
        return CoreDataEntities<GithubUserEntity>.getEntityName()
    }
    
    public init(persistentContainer: NSPersistentContainer = CoreDataClient.shared.persistentContainer, viewContext: NSManagedObjectContext = CoreDataClient.shared.persistentContainer.newBackgroundContext()) {
        self.persistentContainer = persistentContainer
        self.viewContext = viewContext
    }
    
    public func insertEntity(entityName: String, into: NSManagedObjectContext) -> NSManagedObject? {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: into)
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
            guard let userEntity = insertEntity(entityName: self.entityName, into: taskContext) as? GithubUserEntity else {
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
}
