//
//  GithubService.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation

public class GithubService: Service {
    var localDataSource: LocalDataSource
    var remoteDataSource: RemoteDataSource
    
    init(localDataSource: LocalDataSource, remoteDataSource: RemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
}


