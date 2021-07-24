//
//  GithubViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation


class GithubViewModel: AbstractGithubViewModel {
    var service: Service
    
    init(service: Service) {
        self.service = service
    }
}
