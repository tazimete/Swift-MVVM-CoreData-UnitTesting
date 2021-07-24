//
//  BaseViewController.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import UIKit


class BaseViewController: UIViewController {
    public let TAG = description()
    public var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindViewModel()
        
        initNavigationBar()
        
        initView()
        
        setDataSource()
    }
    
    // bind respective viewmodel
    public func bindViewModel() {
        // TODO: Implement in child Class
    }
    
    // initialize navigation bar
    public func initNavigationBar() {
        // TODO: Implement in child Class
    }
    
    //initialize its subview
    public func initView() {
        // TODO: Implement in child Class
    }
    
    //set its data source for subview/table/collection view
    public func setDataSource() {
        // TODO: Implement in child Class
    }
    
    //show alert dialog
    public func alert(_ title: String, text: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: handler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
