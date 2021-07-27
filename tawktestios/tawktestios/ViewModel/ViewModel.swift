//
//  AbstractViewModel.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import Foundation
import RxFlow

//protocol InputOutputType: AnyObject {
//    associatedtype Input
//    associatedtype Output
//    
//    func transform(input: Input) -> Output
//}

protocol ViewModel: Stepper{
    var service: Service {get set}
}

