//
//  GenericCell.swift
//  tawktestios
//
//  Created by JMC on 6/8/21.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType)
}

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
}

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {
    
    static var reuseId: String { return String(describing: CellType.self) }
    
    let item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
}


typealias GithubUserNormalCellConfig = TableCellConfigurator<GithubUserCellNormal, AbstractCellViewModel>
typealias GithubUserNoteCellConfig = TableCellConfigurator<GithubUserCellNote, AbstractCellViewModel>
typealias GithubUserInvertedCellConfig = TableCellConfigurator<GithubUserCellInverted, AbstractCellViewModel>

class TableViewModel {
    var items: [CellConfigurator] = []
}
