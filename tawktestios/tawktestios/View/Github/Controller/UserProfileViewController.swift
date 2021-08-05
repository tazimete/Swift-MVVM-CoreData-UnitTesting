//
//  UserProfileViewController.swift
//  tawktestios
//
//  Created by JMC on 4/8/21.
//

import UIKit

class UserProfileViewController: BaseViewController<GithubService, GithubUser, GithubUserEntity>, Storyboarded  {
    private var userProfileViewModel: UserProfileViewModel!
    public var githubUser: GithubUser?
    
    //MARK: Outlet
    @IBOutlet weak var ivProfilePicture: UIImageView!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblFollwer: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    
    
    public static func instantiate(viewModel: ViewModel<S, D, T>) -> Self {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "UserProfileViewController") as! UserProfileViewController
        vc.viewModel = viewModel
        return vc as! Self
    }
    
    override public init(viewModel: ViewModel<S, D, T>) {
        super.init(viewModel: viewModel)
    }
    
    override required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func initView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserProfileViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
    
    override func initNavigationBar() {
        
    }
    
    override func bindViewModel() {
        userProfileViewModel = viewModel as! UserProfileViewModel
        
        guard let user = githubUser else {
            return
        }
        
        userProfileViewModel.fetchProfile(username: user.username ?? "")
        
        userProfileViewModel.dataFetchingSuccessHandler = {[weak self] in
            self?.lblName.text = "Name : \(self?.userProfileViewModel.data?.username ?? "")"
            self?.lblFollwer.text = "Followers : \(self?.userProfileViewModel.data?.followers ?? 0)"
            self?.lblFollowing.text = "Follwings : \(self?.userProfileViewModel.data?.followings ?? 0)"
            self?.lblCompany.text = "Company : \(self?.userProfileViewModel.data?.company ?? "")"
            self?.lblBlog.text = "Blog : \(self?.userProfileViewModel.data?.blog ?? "")"
            self?.ivProfilePicture.loadImage(from: self?.userProfileViewModel.data?.avatarUrl ?? "" ) {
                [weak self] url, image, isCache in
                
                guard let weakSelf = self else {
                    return
                }
                
                self?.ivProfilePicture.image = image
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}