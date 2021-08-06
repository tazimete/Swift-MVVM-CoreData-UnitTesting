//
//  BaseViewController.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import UIKit
import CoreData

class BaseViewController<S: Service, D: AbstractDataModel & Codable, T: NSManagedObject>: UIViewController, UIScrollViewDelegate {
    typealias S = S
    typealias D = D
    typealias T = T
    
    public let TAG = description()
    public var viewModel: ViewModel<S, D, T>!
    public var lastContentOffset: CGFloat = 0.0
    
    enum ScrollDirection : Int {
        case none
        case right
        case left
        case up
        case down
        case crazy
    }
    
    public init(viewModel: ViewModel<S, D, T>) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
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
    
    
    // MARK: Pagination
    public func getScrollDirection(scrollView:UIScrollView) -> ScrollDirection{
        var scrollDirection: ScrollDirection = .none
        
        if lastContentOffset > scrollView.contentOffset.y {
            scrollDirection = .up
        } else if lastContentOffset < scrollView.contentOffset.y {
            scrollDirection = .down
        }
        
        lastContentOffset = scrollView.contentOffset.y
        
        return scrollDirection
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            onEndScrolling(scView: scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        onEndScrolling(scView: scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            onEndScrolling(scView: scrollView)
        }
    }
    
    // To be overriden by child classes
    public func hasMoreData() -> Bool{
        fatalError("Must Override")
        return false
    }
    
    public func loadMoreData() -> Void{
        fatalError("Must Override")
    }
    
    public func getFirstVisibleItem() -> IndexPath{
        return IndexPath(row: 0, section: 0)
    }
    
    public func getLastVisibleItem() -> IndexPath{
        fatalError("Must Override")
        return IndexPath(row: 0, section: 0)
    }
    
    public func getTotalDataCount() -> Int{
        fatalError("Must Override")
        return 0
    }
    
    public func getPaginationOffset() -> Int{
        fatalError("Must Override")
        return 20
    }
    
    public func onEndScrolling(scView: UIScrollView) -> Void{
        if getScrollDirection(scrollView: scView) == .down{
            if(hasMoreData()){
                let firstVisibleItem = getFirstVisibleItem()
                let lastVisibleItem = getLastVisibleItem()
                
                print("\(BaseViewController.self.description()) -- scrollViewDidScroll() -- down, lastVisibleItem = \(lastVisibleItem), dataCount = \(getTotalDataCount())")
                
                if ( lastVisibleItem.row > getTotalDataCount()-getPaginationOffset()) {
                    loadMoreData();
                }
            }
        }
    }
}


