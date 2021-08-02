//
//  Service.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import CoreData

public protocol Service: AnyObject {
    associatedtype L: AbstractLocalDataSource
    associatedtype R: AbstractRemoteDataSource
    
    var localDataSource: L {get set}
    var remoteDataSource: R {get set}
}

