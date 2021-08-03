//
//  CoreDataClientTest.swift
//  tawktestiosTests
//
//  Created by JMC on 2/8/21.
//

import XCTest
import CoreData

class CoreDataClientTest {
    static let shared = CoreDataClientTest()
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "tawktestios")
        let description = persistentContainer.persistentStoreDescriptions.first
//        description?.type = NSSQLiteStoreType
//        let description = NSPersistentStoreDescription()
        description?.type = NSSQLiteStoreType
        description?.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.persistentStoreDescriptions = [description!]
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator

        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }
}


