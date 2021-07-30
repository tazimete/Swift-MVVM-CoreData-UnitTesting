//
//  Service.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation


protocol Service: AnyObject {
    var localDataSource: LocalDataSource {get set}
    var remoteDataSource: RemoteDataSource {get set}
}

