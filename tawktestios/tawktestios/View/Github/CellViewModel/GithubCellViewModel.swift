//
//  GithubUserNormalViewModel.swift
//  tawktestios
//
//  Created by JMC on 6/8/21.
//

import Foundation


public class GithubCellNormalViewModel: AbstractCellViewModel {
    public var id: String?
    
    public var thumbnail: String?
    
    public var title: String?
    
    public var subtitle: String?
    
    public var note: String?
    
    public var isSeen: Bool?
    
    init() {
        
    }
    
    init(id: String?, thumbnail: String?, title: String?, subtitle: String?, note: String?, isSeen: Bool?) {
        self.id = id
        self.thumbnail = thumbnail
        self.title = title
        self.subtitle = subtitle
        self.note = note
        self.isSeen = isSeen
    }
}
