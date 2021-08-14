//
//  DataModelConverter.swift
//  tawktestios
//
//  Created by JMC on 15/8/21.
//

import Foundation

public class DataModelConverter {
    public func asDictionary(of data: AbstractDataModel & Codable) -> [String: Any] {
        var dictionary = [String: Any]()
        
        if let user = (data as? GithubUser) {
            dictionary = user.asDictionary ?? [String: Any]()
        }

        return dictionary
    }
}
