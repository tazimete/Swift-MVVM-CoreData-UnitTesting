//
//  CoreDataStack.swift
//  tawktestios
//
//  Created by JMC on 29/7/21.
//

import CoreData


public class CoreDataClient {
    public static let shared = CoreDataClient()
    public let persistentContainer: NSPersistentContainer
    public let backgroundContext: NSManagedObjectContext
    public let mainContext: NSManagedObjectContext

    private init() {
        persistentContainer = NSPersistentContainer(name: "tawktestios")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        persistentContainer.persistentStoreDescriptions = [description!]

        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }

        mainContext = persistentContainer.viewContext
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator

        backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

}
