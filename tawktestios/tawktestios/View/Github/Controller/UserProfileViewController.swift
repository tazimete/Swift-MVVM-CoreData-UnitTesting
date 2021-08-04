//
//  UserProfileViewController.swift
//  tawktestios
//
//  Created by JMC on 4/8/21.
//

import UIKit

class UserProfileViewController: BaseViewController<GithubService, GithubUser, GithubUserEntity>, Storyboarded  {
    private var githubViewModel: GithubViewModel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initView() {
        
    }
    
    override func initNavigationBar() {
        
    }
    
    override func bindViewModel() {
        
    }
}
