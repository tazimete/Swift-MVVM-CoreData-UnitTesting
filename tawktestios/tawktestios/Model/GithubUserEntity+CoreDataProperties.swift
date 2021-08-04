//
//  GithubUserEntity+CoreDataProperties.swift
//  
//
//  Created by JMC on 5/8/21.
//
//

import Foundation
import CoreData


extension GithubUserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GithubUserEntity> {
        return NSFetchRequest<GithubUserEntity>(entityName: "GithubUserEntity")
    }

    @NSManaged public var avatarUrl: String?
    @NSManaged public var id: Int64
    @NSManaged public var url: String?
    @NSManaged public var username: String?
    @NSManaged public var note: String?
    @NSManaged public var isSeen: Bool
    @NSManaged public var company: String?
    @NSManaged public var blog: String?
    @NSManaged public var followers: Int64
    @NSManaged public var followings: Int64

}

extension GithubUserEntity {
    public func update(user: AbstractDataModel) {
        id = Int64((user.id ?? -1))

        let githubUser  = user as? GithubUser
        username = githubUser?.username
        avatarUrl = githubUser?.avatarUrl
        url = githubUser?.url
        note = githubUser?.note
        company = githubUser?.company
        blog = githubUser?.blog
        followers = Int64(githubUser?.followers ?? 0)
        followings = Int64(githubUser?.followings ?? 0)
        isSeen = githubUser?.isSeen ?? false
    }

    public var asGithubUser: GithubUser {
        let user = GithubUser()
        user.id = Int(id)
        user.username = username
        user.avatarUrl = avatarUrl
        user.url = url
        user.note = note
        user.company = company
        user.blog = blog
        user.followers = Int(followers)
        user.followings = Int(followings)
        user.isSeen = isSeen
        return user
    }
}
