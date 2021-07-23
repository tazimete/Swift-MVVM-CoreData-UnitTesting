//
//  Network.swift
//  tawktestios
//
//  Created by JMC on 23/7/21.
//

import Foundation

enum GithubApiRequest {
    case fetchUserList(params: Parameterizable)
    case fetchUserProfile(params: Parameterizable)
}

extension GithubApiRequest: APIRequest {
    var baseURL: URL {
        let url =  "https://api.github.com"
        return URL(string: url)!
    }
    
    var method: RequestType {
        switch self {
            case .fetchUserList: return .GET
            case .fetchUserProfile: return .GET
        }
    }
    
    var path: String {
        switch self {
            case .fetchUserList: return "users"
            case .fetchUserProfile: return ""
        }
    }
    
    var parameters: [String: Any]{
        var parameter: [String: Any] = [:]
        
        switch self {
            case .fetchUserList (let params):
                parameter = params.asRequestParam
                
            case .fetchUserProfile (let params):
                parameter = params.asRequestParam
        }
        
        return parameter
    }
    
    var headers: [String: Any] {
        return [String: Any]()
    }
}


