//
//  GithubService.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import CoreData

/*
 As we will fetch github user info, we creating github service by providing LocalDataSource (with GithubUser and GithubUserEntity) and RemoteDataSource (with GithubApiRequest and GithubUser)
 */

public class GithubService: Service {
    public typealias L = LocalDataSource<GithubUser, GithubUserEntity>
    public typealias R = RemoteDataSource<GithubApiRequest, GithubUser>
    
    public var localDataSource: LocalDataSource<GithubUser, GithubUserEntity>
    
    public var remoteDataSource: RemoteDataSource<GithubApiRequest, GithubUser>

    public init(localDataSource: LocalDataSource<GithubUser, GithubUserEntity>, remoteDataSource: RemoteDataSource<GithubApiRequest, GithubUser>) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
}


