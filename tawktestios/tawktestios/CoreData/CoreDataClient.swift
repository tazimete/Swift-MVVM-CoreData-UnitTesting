//
//  CoreDataStack.swift
//  tawktestios
//
//  Created by JMC on 29/7/21.
//

import CoreData


public class CoreDataClient {
//    private init() {}
    
    public static let shared = CoreDataClient()
    
//    lazy var persistentContainer: NSPersistentContainer = {
//       let container = NSPersistentContainer(name: "tawktestios")
//
//        let description = persistentContainer.persistentStoreDescriptions.first
//        description?.type = NSSQLiteStoreType
//
//        persistentContainer.loadPersistentStores { description, error in
//            guard error == nil else {
//                fatalError("was unable to load store \(error!)")
//            }
//        }
////        container.loadPersistentStores(completionHandler: { (_, error) in
////            guard let error = error as NSError? else { return }
////            fatalError("Unresolved error: \(error), \(error.userInfo)")
////        })
//
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        container.viewContext.undoManager = nil
//        container.viewContext.shouldDeleteInaccessibleFaults = true
//
//        container.viewContext.automaticallyMergesChangesFromParent = true
//
//        return container
//    }()
    
    public let persistentContainer: NSPersistentContainer
    public let backgroundContext: NSManagedObjectContext
    public let mainContext: NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "tawktestios")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        mainContext = persistentContainer.viewContext
        
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }
}
