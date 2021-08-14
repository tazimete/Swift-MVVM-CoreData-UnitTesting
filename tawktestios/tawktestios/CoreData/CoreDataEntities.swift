//
//  CoreDataEntities.swift
//  tawktestios
//
//  Created by JMC on 1/8/21.
//

import CoreData


enum CoreDataEntities<T: NSManagedObject>: String {
    case GithubUserEntity = "GithubUserEntity"
    case None = ""
    
    public static func getEntityName() -> String{
        if T.self is GithubUserEntity.Type  {
            return CoreDataEntities.GithubUserEntity.rawValue
        }

        return CoreDataEntities.None.rawValue
    }
}


public class DataModelConverter {
    public func asDictionary(of data: AbstractDataModel & Codable) -> [String: Any] {
        var dictionary = [String: Any]()
        
        if let user = (data as? GithubUser) {
            dictionary = user.asDictionary ?? [String: Any]()
        }

        return dictionary
    }
}
