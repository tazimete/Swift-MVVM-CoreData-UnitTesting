//
//  DataProvider.swift
//  tawktestios
//
//  Created by JMC on 29/7/21.
//

import CoreData


/*
 This is local data source of our project, It uses generic data model (AbstractDataModel/NSManagedObject ) to store and retrieve data which is actually server response, must be conformed from AbstractdataModel.
  Write response data to NSManagedObject model, which is coredata model. Its used to  create, fetche, update, delete, sync, search  AbstractdataModel to coredata.
 */

public class LocalDataSource<T: AbstractDataModel, D: NSManagedObject> : AbstractLocalDataSource{
    public typealias T = T
    public typealias D = D
    
    public let TAG = "LocalDataSource"
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
    
    public func insertEntity(entityName: String, into context: NSManagedObjectContext) -> D? {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? D
    }
    
    public func fetchItems(taskContext: NSManagedObjectContext) -> [D] {
        let fetchRequest = NSFetchRequest<D>(entityName: CoreDataEntities<D>.getEntityName())
        let sort = NSSortDescriptor(key:"id", ascending:true)
        fetchRequest.sortDescriptors = [sort]
        
        var userEntities: [D]!
        
        do {
            userEntities = try taskContext.fetch(fetchRequest)
        } catch let error {
            print("\(TAG) -- Failed to fetch companies: \(error)")
        }
        
        return userEntities
    }
    
    public func fetchItems(ids: [Int], taskContext: NSManagedObjectContext) -> [D] {
        let fetchRequest = NSFetchRequest<D>(entityName: CoreDataEntities<D>.getEntityName())
        fetchRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [ids])
        let sort = NSSortDescriptor(key:"id", ascending:true)
        fetchRequest.sortDescriptors = [sort]
        
        var userEntities: [D]!
        
        do {
            userEntities = try taskContext.fetch(fetchRequest)
        } catch let error {
            print("\(TAG) -- Failed to fetch companies: \(error)")
        }
        
        return userEntities
    }
    
    public func insertItems(items: [T], taskContext: NSManagedObjectContext) {
//        taskContext.performAndWait {
            for item in items {
                guard let userEntity = self.insertEntity(entityName: self.entityName, into: taskContext) else {
                    print("\(self.TAG) -- Error: Failed to create a new user object!")
                    return
                }

                do {
                    if let entity = userEntity as? GithubUserEntity {
                        try entity.update(user: item)
                    }
                    
                    try taskContext.save()
                } catch (let error){
                    print("\(self.TAG) -- Error: \(error)\n this object will be deleted.")
                    taskContext.delete(userEntity)
                }
            }
//        }
        
    }
    
    public func updateItem(item: D, taskContext: NSManagedObjectContext) {
        do {
            try taskContext.save()
        } catch let error {
            print("\(TAG) -- Failed to update: \(error)")
        }
    }
    
    public func batchDeleteItems(ids: [Int], taskContext: NSManagedObjectContext) {
        //removing batch delete request, because its not working inMemoryStore Type 
//        let fRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        fetchRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [ids])

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
        
        // batch delete is not working in InMemoryStoreType for unit testing, thats why deleting manually
        let items = fetchItems(ids: ids, taskContext: taskContext)
        
        for item in items {
            taskContext.delete(item)
        }
        
        try? taskContext.save()
    }
    
    public func deleteAllItems(taskContext: NSManagedObjectContext) {
        let items = fetchItems(taskContext: taskContext)
        
        for item in items {
            taskContext.delete(item)
        }
        
        try? taskContext.save()
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
                    print("\(TAG) -- Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successfull = true
        }
        return successfull
    }
    
    //search entity by its properties, properties are added in params by key-value pair
    public func search(params: [String: String], controller: NSFetchedResultsController<D>, isEnded: Bool) {
        var predicateList = [NSPredicate]()
        
        params.forEach({
            key, value in
            
            let pred1: NSPredicate = NSPredicate(format: "\(key) CONTAINS[c] %@", value)
            let pred2: NSPredicate = NSPredicate(format: "\(key) == %@", value)
            
            predicateList.append(pred1)
            predicateList.append(pred2)
        })
        
        var predicates:NSPredicate? = NSCompoundPredicate(orPredicateWithSubpredicates: predicateList)
        
        if isEnded {
            predicates = nil
        }
        
        controller.fetchRequest.predicate = predicates
        
        try? controller.performFetch()
        
        controller.managedObjectContext.refreshAllObjects()
    }
    
    public func clearSearch(controller: NSFetchedResultsController<D>) {
        controller.fetchRequest.predicate = nil
        try? controller.performFetch()
        
        controller.managedObjectContext.refreshAllObjects()
    }
}
