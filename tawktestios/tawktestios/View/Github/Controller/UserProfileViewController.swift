//
//  UserProfileViewController.swift
//  tawktestios
//
//  Created by JMC on 4/8/21.
//

import UIKit

class UserProfileViewController: BaseViewController<GithubService, GithubUser, GithubUserEntity>, Storyboarded  {
    private var userProfileViewModel: UserProfileViewModel!
    public var githubUser: GithubUserEntity?
    
    //MARK: Outlet
    @IBOutlet weak var ivProfilePicture: UIImageView!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblFollwer: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    @IBOutlet weak var tvNote: UITextView!
    
    
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
        
        user.isSeen = true
        userProfileViewModel.updateUserEntity(user: user)
        userProfileViewModel.fetchProfile(username: user.username ?? "")
        
        userProfileViewModel.dataFetchingSuccessHandler = {[weak self] in
            guard let user = self?.userProfileViewModel.data else {
                return
            }
            
            self?.showData(user: user)
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //When tap on save button
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        guard let user = githubUser else {
            return
        }
        
        user.note = tvNote.text.isEmpty ? nil : tvNote.text 
        
        userProfileViewModel.updateUserEntity(user: user)
    }
    
    
    private func showData(user: GithubUser) {
        self.lblName.text = "Name : \(user.username ?? "")"
        self.lblFollwer.text = "Followers : \(user.followers ?? 0)"
        self.lblFollowing.text = "Follwings : \(user.followings ?? 0)"
        self.lblCompany.text = "Company : \(user.company ?? "")"
        self.lblBlog.text = "Blog : \(user.blog ?? "")"
        self.ivProfilePicture.loadImage(from: user.avatarUrl ?? "" ) {
            [weak self] url, image, isCache in
            self?.ivProfilePicture.image = image
        }
    }
}
