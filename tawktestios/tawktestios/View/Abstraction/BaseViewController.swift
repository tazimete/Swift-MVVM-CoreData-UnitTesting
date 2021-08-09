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
    public let reachability = try! Reachability()
    public var notificationBanner = StatusBarNotificationBanner(title: "No internet connection", style: .danger)
    public let notificationBannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
    public var isShimmerNeeded: Bool = false
    public var isPaginationEnabled: Bool = true
    public weak var subViewController: UIViewController?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
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
        initReachability()
    }
    
    //initialize its subview
    public func setSubViewController(viewController: UIViewController) {
        self.subViewController = viewController
    }
    
    //set its data source for subview/table/collection view
    public func setDataSource() {
        // TODO: Implement in child Class
    }
    
    
    public func initReachability() {
        notificationBanner.autoDismiss = false
       
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
    }
    
    @objc public func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        notificationBanner.dismiss()
        
        switch reachability.connection {
        case .wifi:
            print("Wifi Connection")
            
            notificationBanner = StatusBarNotificationBanner(title: "Internet connection available", style: .success)
            notificationBanner.autoDismiss = true
            notificationBanner.show(queuePosition: .front, bannerPosition: .bottom, queue: notificationBannerQueue, on: subViewController)
    
            //load last request
            didReachabilityConnected()
            
        case .cellular:
            print("Cellular Connection")
            
            notificationBanner = StatusBarNotificationBanner(title: "Internet connection available", style: .success)
            notificationBanner.autoDismiss = true
            notificationBanner.show(queuePosition: .front, bannerPosition: .bottom, queue: notificationBannerQueue, on: subViewController)
            
            //load last request
            didReachabilityConnected()
            
        case .unavailable:
            print("No Connection")
            
            notificationBanner = StatusBarNotificationBanner(title: "No internet connection", style: .danger)
            notificationBanner.autoDismiss = false
            notificationBanner.show(queuePosition: .front, bannerPosition: .bottom, queue: notificationBannerQueue, on: subViewController)
            
            //load last request
            didReachabilityConnected()
            
        case .none:
            print("No Connection")
            
            notificationBanner = StatusBarNotificationBanner(title: "No internet connection", style: .danger)
            notificationBanner.autoDismiss = false
            notificationBanner.show(queuePosition: .front, bannerPosition: .bottom, queue: notificationBannerQueue, on: subViewController)
            
            // call back for disconnection
            didReachabilityDisConnected()
        }
    }
    
    //load data when internet connected
    public func didReachabilityConnected() {
        
    }
    
    //load data when internet disconnected
    public func didReachabilityDisConnected() {
        
    }
    
    //disbale keyboard
    public func disableKeyboard(tappingView: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserProfileViewController.dismissKeyboard))
        tappingView.isUserInteractionEnabled = true 
        tappingView.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //show alert dialog
    public func alert(_ title: String, text: String, actionTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: handler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Pagination
    enum ScrollDirection : Int {
        case none
        case right
        case left
        case up
        case down
        case crazy
    }
    
    public var lastContentOffset: CGFloat = 0.0
    
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
                
//                print("\(BaseViewController.self.description()) -- scrollViewDidScroll() -- down, lastVisibleItem = \(lastVisibleItem), dataCount = \(getTotalDataCount())")
                
                //load more data if indexpath is greater than total data count/offset 
                if ( lastVisibleItem.row > getTotalDataCount()-getPaginationOffset()) {
                    loadMoreData();
                }
            }
        }
    }
}


