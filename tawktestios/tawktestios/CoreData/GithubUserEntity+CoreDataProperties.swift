//
//  GithubUserEntity+CoreDataProperties.swift
//  
//
//  Created by JMC on 30/7/21.
//
//

import Foundation
import CoreData


extension GithubUserEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GithubUserEntity> {
        return NSFetchRequest<GithubUserEntity>(entityName: "GithubUserEntity")
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var username: String?
    @NSManaged public var avatarUrl: String?
    @NSManaged public var url: String?
    @NSManaged public var note: String?
    @NSManaged public var isSeen: Bool
}


extension GithubUserEntity {
    public func update(user: AbstractDataModel){
        id = Int64((user.id ?? -1))
        
        let githubUser  = user as? GithubUser
        
        username = githubUser?.username
        avatarUrl = githubUser?.avatarUrl
        url = githubUser?.url
        note = githubUser?.note
        isSeen = githubUser?.isSeen ?? false
    }
    
    public var asGithubUser: GithubUser{
        let user = GithubUser()
        user.id = Int(id)
        user.username = username
        user.avatarUrl = avatarUrl
        user.url = url
        user.note = note
        user.isSeen = isSeen
        return user
    }
}
