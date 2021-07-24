//
//  GithubUserParams.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation


public class FetchGithubUserParams: Parameterizable{
    let since: Int

    public init(since: Int) {
        self.since = since
    }

    private enum CodingKeys: String, CodingKey {
        case since = "since"
    }

    public var asRequestParam: [String: Any] {
        let param: [String: Any?] = [CodingKeys.since.rawValue: since]
        return param.compactMapValues { $0 }
    }
}
