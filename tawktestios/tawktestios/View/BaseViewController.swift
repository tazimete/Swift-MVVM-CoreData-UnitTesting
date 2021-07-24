//
//  BaseViewController.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        
        initNavigationBar()
        
        setDataSource()
        
        bindViewModel()
    }
    
    public func initView() {
        // TODO: Implement in child Class
    }
    
    public func initNavigationBar() {
        // TODO: Implement in child Class
    }
    
    public func setDataSource() {
        // TODO: Implement in child Class
    }
    
    public func bindViewModel() {
        // TODO: Implement in child Class
    }
    
    public func alert(_ title: String, text: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
}
