//
//  DataProvider.swift
//  tawktestios
//
//  Created by JMC on 29/7/21.
//

import CoreData

//let dataErrorDomain = "dataErrorDomain"

class ApiRepository {

}

enum DataErrorCode: NSInteger {
    case networkUnavailable = 101
    case wrongDataFormat = 102
}

class DataProvider {
    
    public let persistentContainer: NSPersistentContainer
    private let repository: ApiRepository
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer, repository: ApiRepository) {
        self.persistentContainer = persistentContainer
        self.repository = repository
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
    
    public func syncFilms(jsonDictionary: [GithubUser], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        
        taskContext.performAndWait {
            let matchingEpisodeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GithubUserEntity")
            let episodeIds = jsonDictionary.map { $0.id ?? -1 }.compactMap { $0 }
            matchingEpisodeRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [episodeIds])
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingEpisodeRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            }catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            // Create new records.
            for filmDictionary in jsonDictionary {
                
                guard let film = NSEntityDescription.insertNewObject(forEntityName: "GithubUserEntity", into: taskContext) as? GithubUserEntity else {
                    print("Error: Failed to create a new Film object!")
                    return
                }
                
                do {
                    try film.update(user: filmDictionary)
                } catch {
                    print("Error: \(error)\nThe quake object will be deleted.")
                    taskContext.delete(film)
                }
            }
            
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
