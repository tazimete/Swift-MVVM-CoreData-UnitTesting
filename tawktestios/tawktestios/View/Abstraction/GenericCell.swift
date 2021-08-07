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
    func startShimmerAnimation() -> Void
    func stopShimmerAnimation() -> Void
}

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
    func startShimmerAnimation(cell: UIView)
    func stopShimmerAnimation(cell: UIView)
}

class TableViewCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {
    
    static var reuseId: String { return String(describing: CellType.self) }
    
    let item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
    
    func startShimmerAnimation(cell: UIView) {
        (cell as! CellType).startShimmerAnimation()
    }
    
    func stopShimmerAnimation(cell: UIView) {
        (cell as! CellType).stopShimmerAnimation()
    }
}


typealias GithubUserNormalCellConfig = TableViewCellConfigurator<GithubUserCellNormal, AbstractCellViewModel>
typealias GithubUserNoteCellConfig = TableViewCellConfigurator<GithubUserCellNote, AbstractCellViewModel>
typealias GithubUserInvertedCellConfig = TableViewCellConfigurator<GithubUserCellInverted, AbstractCellViewModel>

class TableViewDataSource {
    private var items: [CellConfigurator] = []
    
    public func getCellConfigurator(cellViewModel: AbstractCellViewModel, index: Int) -> CellConfigurator? {
        var cellConfig: CellConfigurator!
        
        if (cellViewModel.hasNote ?? false) {
            cellConfig = GithubUserNoteCellConfig.init(item: cellViewModel)
        }
        
        else if (index % 4 == 0) { //every forth cell
            cellViewModel.isInverted = true 
            cellConfig = GithubUserInvertedCellConfig.init(item: cellViewModel)
        }
        
        else {
            cellConfig = GithubUserNormalCellConfig.init(item: cellViewModel)
        }
        
        return cellConfig
    }
    
    public func addAsCellConfigurator(cellViewModel: AbstractCellViewModel) {
        if (cellViewModel.hasNote ?? false) {
            let cellConfig = GithubUserNoteCellConfig.init(item: cellViewModel)
            items.append(cellConfig)
        }
        
        else if (cellViewModel.isInverted ?? false) {
            let cellConfig = GithubUserInvertedCellConfig.init(item: cellViewModel)
            items.append(cellConfig)
        }
        
        else {
            let cellConfig = GithubUserNormalCellConfig.init(item: cellViewModel)
            items.append(cellConfig)
        }
    }
   
    public func addAllAsCellConfigurator(cellViewModels: [AbstractCellViewModel]) {
        for cellViewModel in cellViewModels {
            if (cellViewModel.hasNote ?? false) {
                let cellConfig = GithubUserNoteCellConfig.init(item: cellViewModel)
                items.append(cellConfig)
            }
            
            else if (cellViewModel.isInverted ?? false) {
                let cellConfig = GithubUserInvertedCellConfig.init(item: cellViewModel)
                items.append(cellConfig)
            }
            
            else {
                let cellConfig = GithubUserNormalCellConfig.init(item: cellViewModel)
                items.append(cellConfig)
            }
        }
    }

    public func clearAndaddAllAsCellConfigurator(cellViewModels: [AbstractCellViewModel]) {
        items.removeAll()
        
        for cellViewModel in cellViewModels {
            if (cellViewModel.hasNote ?? false) {
                let cellConfig = GithubUserNoteCellConfig.init(item: cellViewModel)
                items.append(cellConfig)
            }
            
            else if (cellViewModel.isInverted ?? false) {
                let cellConfig = GithubUserInvertedCellConfig.init(item: cellViewModel)
                items.append(cellConfig)
            }
            
            else {
                let cellConfig = GithubUserNormalCellConfig.init(item: cellViewModel)
                items.append(cellConfig)
            }
        }
    }
    
    public func addCellConfigurator(cellConfig: CellConfigurator) {
        items.append(cellConfig)
    }
    
    public func insertAsCellConfigurator(cellViewModel: AbstractCellViewModel, at index: Int) {
        if (cellViewModel.hasNote ?? false) {
            let cellConfig = GithubUserNoteCellConfig.init(item: cellViewModel)
            items.insert(cellConfig, at: index)
        }
        
        else if (cellViewModel.isInverted ?? false) {
            let cellConfig = GithubUserInvertedCellConfig.init(item: cellViewModel)
            items.insert(cellConfig, at: index)
        }
        
        else {
            let cellConfig = GithubUserNormalCellConfig.init(item: cellViewModel)
            items.insert(cellConfig, at: index)
        }
    }
    
    public func insertCellConfigurator(cellConfig: CellConfigurator, at index: Int) {
        items.insert(cellConfig, at: index)
    }
    
    public func getCellConfigurator(at index: Int) -> CellConfigurator {
        return items[index]
    }
    
    public func updateCellConfigurator(cellConfig: CellConfigurator, at index: Int) {
        items[index] = cellConfig
    }
    
    public func getCount() -> Int {
        return items.count
    }
    
    public func getLastItem() -> CellConfigurator? {
        return items.last
    }
    
    public func removeCellConfigurator(at index: Int) {
        let cournt = items.count;
        items.remove(at: index)
    }
    
    public func removeAll() {
        return items.removeAll()
    }
}
