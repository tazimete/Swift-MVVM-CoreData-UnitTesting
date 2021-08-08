//
//  Service.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import CoreData


/*
 Abstraction of service which contains two data source (local and remote) to process data from/into remote server and local database 
 */

public protocol Service: AnyObject {
    associatedtype L: AbstractLocalDataSource
    associatedtype R: AbstractRemoteDataSource
    
    var localDataSource: L {get set}
    var remoteDataSource: R {get set}
}

