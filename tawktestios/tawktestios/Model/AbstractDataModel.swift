//
//  AbstractDataModel.swift
//  tawktestios
//
//  Created by JMC on 5/8/21.
//

import Foundation


/*
 Base class for our server response
 */

public protocol AbstractDataModel: AnyObject {
    var id: Int? {get set}
    var asDictionary : [String: Any]? {get}
}

