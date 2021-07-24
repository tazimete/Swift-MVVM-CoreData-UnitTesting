//
//  GithubService.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation

public class GithubService: Service {
    var localDataSource: DataSource
    var remoteDataSource: DataSource
    
    init(localDataSource: DataSource, remoteDataSource: DataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
}


