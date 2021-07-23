//
//  ApiRequest.swift
//  tawktestios
//
//  Created by JMC on 23/7/21.
//

import Foundation


public enum RequestType: String {
    case GET, POST, DELETE, PUT, PATCH
}

protocol APIRequest {
    var baseURL: URL {get}
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var headers: [String: Any] {get}
}

extension APIRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: $1 as! String)
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}



