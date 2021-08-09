//
//  TableViewDataSource.swift
//  tawktestios
//
//  Created by JMC on 7/8/21.
//

import UIKit


typealias GithubUserNormalCellConfig = TableViewCellConfigurator<GithubUserCellNormal, AbstractCellViewModel>
typealias GithubUserNoteCellConfig = TableViewCellConfigurator<GithubUserCellNote, AbstractCellViewModel>
typealias GithubUserInvertedCellConfig = TableViewCellConfigurator<GithubUserCellInverted, AbstractCellViewModel>
typealias GithubUserShimmerCellConfig = TableViewCellConfigurator<GithubUserShimmerCell, AbstractCellViewModel>


// collection of cell configurator
class TableViewCellConfiguratorFactory {
    private var items: [CellConfigurator] = []
    
    //get cell confurator by cellviewmodel
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
    
    //add cell configurator converted from cellviewmodel
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
   
    //add multiple cell configurator converted from cellviewmodel
    public func addAllAsCellConfigurator(cellViewModels: [AbstractCellViewModel]) {
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
    
    public func updateAsCellConfigurator(cellViewModel: AbstractCellViewModel, at index: Int) {
        if (cellViewModel.hasNote ?? false) {
            let cellConfig = GithubUserNoteCellConfig.init(item: cellViewModel)
            items[index] = cellConfig
        }
        
        else if (cellViewModel.isInverted ?? false) {
            let cellConfig = GithubUserInvertedCellConfig.init(item: cellViewModel)
            items[index] = cellConfig
        }
        
        else {
            let cellConfig = GithubUserNormalCellConfig.init(item: cellViewModel)
            items[index] = cellConfig
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
        let count = items.count;
        items.remove(at: index)
    }
    
    public func removeAll() {
        return items.removeAll()
    }
}
