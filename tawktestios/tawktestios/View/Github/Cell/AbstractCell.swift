//
//  AbstractCell.swift
//  tawktestios
//
//  Created by JMC on 3/8/21.
//

import Foundation

public protocol AbstractCell: AnyObject {
    var viewModel: AbstractCellviewModel {get set}
    
    func configure(viewModel: AbstractCellviewModel)
}
