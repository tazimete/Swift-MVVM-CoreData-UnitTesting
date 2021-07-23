//
//  Network.swift
//  tawktestios
//
//  Created by JMC on 23/7/21.
//

import Foundation

public class FetchGithubUserParams: Parameterizable{
    let query: String

    public init(query: String) {
        self.query = query
    }

    private enum CodingKeys: String, CodingKey {
        case query = "query"
    }

    public var asRequestParam: [String: Any] {
        let param: [String: Any?] = [CodingKeys.query.rawValue: query]
        return param.compactMapValues { $0 }
    }
}

enum GithubApiRequest {
    case fetchUserList(params: [String: Any])
    case fetchUserProfile(params: [String: Any])
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
                parameter["since"] = params["since"]
                
            case .fetchUserProfile (let params):
                parameter["since"] = params["since"]
        }
        
        return parameter
    }
    
    var headers: [String: Any] {
        var headers: [String: Any] = [String: Any]()
        return headers
    }
}


