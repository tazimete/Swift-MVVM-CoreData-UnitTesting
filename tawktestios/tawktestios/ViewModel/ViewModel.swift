//
//  AbstractViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation

protocol ViewModel: AnyObject{
    associatedtype Input
    associatedtype Output
    
    var service: Service {get set}
    
    func transform(input: Input) -> Output
}

