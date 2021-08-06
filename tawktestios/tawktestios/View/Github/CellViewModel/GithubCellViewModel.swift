//
//  GithubUserNormalViewModel.swift
//  tawktestios
//
//  Created by JMC on 6/8/21.
//

import Foundation


public class GithubCellViewModel: AbstractCellViewModel {
    public var id: Int?
    public var thumbnail: String?
    public var title: String?
    public var subtitle: String?
    public var hasNote: Bool?
    public var isSeen: Bool?
    public var isInverted: Bool?
    
    init() {
        
    }
    
    init(id: Int?, thumbnail: String?, title: String?, subtitle: String?, hasNote: Bool?, isInverted: Bool? = false, isSeen: Bool?) {
        self.id = id
        self.thumbnail = thumbnail
        self.title = title
        self.subtitle = subtitle
        self.hasNote = hasNote
        self.isInverted = isInverted
        self.isSeen = isSeen
    }
}
