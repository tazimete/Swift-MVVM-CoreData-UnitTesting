//
//  AbstractCellViewModel.swift
//  tawktestios
//
//  Created by JMC on 3/8/21.
//

import Foundation


public protocol AbstractCellViewModel: AnyObject {
    var id: String? {set get}
    var thumbnail: String? {set get}
    var title: String? {set get}
    var subtitle: String? {set get}
    var note: String? {set get}
    var isSeen: Bool? {set get}
}
