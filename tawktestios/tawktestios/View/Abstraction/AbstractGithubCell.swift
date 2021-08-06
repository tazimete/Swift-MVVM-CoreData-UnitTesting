//
//  AbstractCell.swift
//  tawktestios
//
//  Created by JMC on 3/8/21.
//

import UIKit

public protocol AbstractGithubCell: AnyObject{
    var viewModel: AbstractCellViewModel? {get}
    static var cellReuseIdentifier: String {set get}
    
    func configure(viewModel: AbstractCellViewModel)
}
