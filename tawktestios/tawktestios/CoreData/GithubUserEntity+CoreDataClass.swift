//
//  GithubUserEntity+CoreDataClass.swift
//  
//
//  Created by JMC on 30/7/21.
//
//

import Foundation
import CoreData

@objc(GithubUserEntity)
public class GithubUserEntity: NSManagedObject {
    var asGithubUser: GithubUser{
        let user = GithubUser()
        user.id = Int(id)
        user.username = username
        user.avatarUrl = avatarUrl
        user.url = url
        return user
    }
    
    func update(user: GithubUser){
        id = Int64((user.id ?? -1))
        username = user.username
        avatarUrl = user.avatarUrl
        url = user.url
    }
}

//extension GithubUserEntity {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<GithubUserEntity> {
//        return NSFetchRequest<GithubUserEntity>(entityName: "GithubUserEntity")
//    }
//
//    @NSManaged public var id: NSDecimalNumber?
//    @NSManaged public var username: String?
//    @NSManaged public var avatarUrl: String?
//    @NSManaged public var url: String?
//
//}
