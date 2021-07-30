//
//  GithubUser.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import CoreData

//class GithubUserEntity: NSManagedObject {
//    @NSManaged var id: NSNumber?
//    @NSManaged var username: String?
//    @NSManaged var avatarUrl: String?
//    @NSManaged var url: String?
//
//    func update(user: GithubUser){
//        id = NSNumber(value: user.id ?? -1)
//        username = user.username
//        avatarUrl = user.avatarUrl
//        url = user.url
//    }
//}

protocol AbstractDataModel: AnyObject {
    var id: Int? {get set}
}

class GithubUser: AbstractDataModel, Codable {
    var id: Int?
    var username: String?
    var avatarUrl: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "login"
        case avatarUrl = "avatar_url"
        case url = "url"
    }
}


