//
//  GithubUser.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation

class GithubUser: Codable {
    var id: Int?
    var username: String?
    
    enum CodingKeys: String, CodingKey {
            case id = "id"
            case username = "login"
        }
}
