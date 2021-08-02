//
//  DataProvider.swift
//  tawktestios
//
//  Created by JMC on 29/7/21.
//

import CoreData


public class LocalDataSource<T: AbstractDataModel, D: NSManagedObject> : AbstractLocalDataSource{
    public typealias T = T
    public typealias D = D
    
    public var persistentContainer: NSPersistentContainer
    public var viewContext: NSManagedObjectContext
    public lazy var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        let fRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        return fRequest
    }()
    
    public var entityName: String {
        return CoreDataEntities<D>.getEntityName()
    }
    
    public init(persistentContainer: NSPersistentContainer = CoreDataClient.shared.persistentContainer, viewContext: NSManagedObjectContext = CoreDataClient.shared.backgroundContext) {
        self.persistentContainer = persistentContainer
        self.viewContext = viewContext
    }
    
    public func insertEntity(entityName: String, into: NSManagedObjectContext) -> D? {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: into) as? D
    }
    
    public func fetchItems(taskContext: NSManagedObjectContext) -> [D] {
        let fetchRequest = NSFetchRequest<D>(entityName: CoreDataEntities<D>.getEntityName())
        let sort = NSSortDescriptor(key:"id", ascending:true)
        fetchRequest.sortDescriptors = [sort]
        
        var userEntities: [D]!
        
//        taskContext.performAndWait {
            do {
                userEntities = try taskContext.fetch(fetchRequest)
            } catch let error {
                print("Failed to fetch companies: \(error)")
            }
//        }
        
        return userEntities
    }
    
    public func insertItems(items: [T], taskContext: NSManagedObjectContext) {
        for item in items {
            guard let userEntity = insertEntity(entityName: self.entityName, into: taskContext) as? D else {
                print("Error: Failed to create a new user object!")
                return
            }

            do {
                if let entity = userEntity as? GithubUserEntity {
                    try entity.update(user: item)
                }
            } catch {
                print("Error: \(error)\n this object will be deleted.")
                taskContext.delete(userEntity)
            }
        }
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
                                                    into: [taskContext])
            }
        }catch {
            print("Error: \(error)\nCould not batch delete existing records.")
        }
    }
    
    public func syncData(data: [T], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false

        taskContext.performAndWait {
            let userIds = data.map { $0.id ?? -1 }.compactMap { $0 }

            //delete old matched data to get latest and updated data from server
            batchDeleteItems(ids: userIds, taskContext: taskContext)

            // Create new records.
            insertItems(items: data, taskContext: taskContext)

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
}


//class GithubLocalDataSource : LocalDataSource{
////    typealias T = GithubUser
////    typealias D = GithubUserEntity
//    
//    public var persistentContainer: NSPersistentContainer
//    public var viewContext: NSManagedObjectContext
//    public lazy var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
//        let fRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        return fRequest
//    }()
//    
//    public var entityName: String {
//        return CoreDataEntities<GithubUserEntity>.getEntityName()
//    }
//    
//    public init(persistentContainer: NSPersistentContainer = CoreDataClient.shared.persistentContainer, viewContext: NSManagedObjectContext = CoreDataClient.shared.backgroundContext) {
//        self.persistentContainer = persistentContainer
//        self.viewContext = viewContext
//    }
//    
//    public func insertEntity(entityName: String, into: NSManagedObjectContext) -> NSManagedObject? {
//        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: into)
//    }
//    
//    func fetchItems<T>(type: T, taskContext: NSManagedObjectContext) -> [NSManagedObject] where T : NSManagedObject {
//        let fetchRequest = NSFetchRequest<T>(entityName: CoreDataEntities<T>.getEntityName())
//            
//        var userEntities: [T]!
//        
//        taskContext.performAndWait {
//            do {
//                userEntities = try taskContext.fetch(fetchRequest)
//            } catch let error {
//                print("Failed to fetch companies: \(error)")
//            }
//        }
//        
//        return userEntities
//    }
//    
//    public func insertItems<T>(items: [T], taskContext: NSManagedObjectContext) where T : AbstractDataModel {
//        for item in items {
//            guard let userEntity = insertEntity(entityName: self.entityName, into: taskContext) as? GithubUserEntity else {
//                print("Error: Failed to create a new user object!")
//                return
//            }
//
//            do {
//                try userEntity.update(user: item)
//            } catch {
//                print("Error: \(error)\n this object will be deleted.")
//                taskContext.delete(userEntity)
//            }
//        }
//    }
//    
//    public func batchDeleteItems(ids: [Int], taskContext: NSManagedObjectContext) {
//        fetchRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [ids])
//
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        batchDeleteRequest.resultType = .resultTypeObjectIDs
//
//        // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
//        do {
//            let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
//
//            if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
//                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
//                                                    into: [taskContext])
//            }
//        }catch {
//            print("Error: \(error)\nCould not batch delete existing records.")
//        }
//    }
//    
//    public func syncData<T>(data: [T], taskContext: NSManagedObjectContext) -> Bool where T : AbstractDataModel {
//        var successfull = false
//
//        taskContext.performAndWait {
//            let userIds = data.map { $0.id ?? -1 }.compactMap { $0 }
//
//            //delete old matched data to get latest and updated data from server
//            batchDeleteItems(ids: userIds, taskContext: taskContext)
//
//            // Create new records.
//            insertItems(items: data, taskContext: taskContext)
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
//   
//}

