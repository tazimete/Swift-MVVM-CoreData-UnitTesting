//
//  AbstractViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation

protocol InputOutputType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

protocol ViewModel: AnyObject{
    var service: Service {get set}
}

