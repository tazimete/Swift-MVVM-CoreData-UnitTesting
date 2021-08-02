//
//  GithubService.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import CoreData

public class GithubService: Service {
    typealias L = LocalDataSource<GithubUser, GithubUserEntity>
    typealias R = RemoteDataSource<GithubApiRequest, GithubUser>
    
    var localDataSource: LocalDataSource<GithubUser, GithubUserEntity>
    
    var remoteDataSource: RemoteDataSource<GithubApiRequest, GithubUser>

    init(localDataSource: LocalDataSource<GithubUser, GithubUserEntity>, remoteDataSource: RemoteDataSource<GithubApiRequest, GithubUser>) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
}


