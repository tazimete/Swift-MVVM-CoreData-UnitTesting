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
        if T() is GithubUserEntity {
            return CoreDataEntities.GithubUserEntity.rawValue
        }
        
        return CoreDataEntities.None.rawValue
    }
}
