//
//  Service.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation


protocol Service: AnyObject {
    var localDataSource: DataSource {get set}
    var remoteDataSource: DataSource {get set}
}
