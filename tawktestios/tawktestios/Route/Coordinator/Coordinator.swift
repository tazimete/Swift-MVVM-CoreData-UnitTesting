//
//  Coordinator.swift
//  tawktestios
//
//  Created by JMC on 31/7/21.
//

import UIKit
import CoreData


protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}


protocol Storyboarded {
    static func instantiate<T: NSManagedObject, D: AbstractDataModel, S: Service>(viewModel: ViewModel<T, D, S>) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate<T: NSManagedObject, D: AbstractDataModel, S: Service>(viewModel: ViewModel<T, D, S>) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(identifier: className) as! Self
    }
}
