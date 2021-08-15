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
    @IBOutlet weak var uivInfoContainer: UIView!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblFollwer: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    @IBOutlet weak var lblTitleNote: UILabel!
    @IBOutlet weak var tvNote: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    
    
    override public init(viewModel: ViewModel<S, D, T>) {
        super.init(viewModel: viewModel)
    }
    
    override required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startShimmerAnimation()
    }
    
    override func initView() {
        super.initView()
        
        disableKeyboard(tappingView: view)
        ivProfilePicture.contentMode = .scaleAspectFill
        
        //init data
        self.tvNote.text = githubUser?.note
        self.lblFollwer.text = "Followers : \(githubUser?.followers ?? 0)"
        self.lblFollowing.text = "Follwings : \(githubUser?.followings ?? 0)"
    }
    
    //when theme change, we can also define dark mode color option in color asset
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        switch (traitCollection.userInterfaceStyle) {
            case .dark:
                btnSave.layer.borderColor = UIColor.white.cgColor
                btnSave.setTitleColor(.white, for: .normal)
                break
                
            case .light:
                btnSave.layer.borderColor = UIColor.black.cgColor
                btnSave.setTitleColor(.black, for: .normal)
                break
                
            default:
                break
        }
    }
    
    override func initNavigationBar() {
        
    }
    
    override func bindViewModel() {
        userProfileViewModel = viewModel as! UserProfileViewModel
        
        guard let user = githubUser else {
            return
        }
        
        // update profile seen status to local db
        user.isSeen = true
        userProfileViewModel.updateUserEntity(user: user)
        
        //fetch user profile
        fetchUserProfile(user: user)
    }
    
    //when internet connected
    override func didReachabilityConnected() {
        //fetch user data
        guard let user = githubUser else {
            return
        }
        
        startShimmerAnimation()
        fetchUserProfile(user: user)
    }
    
    //MARK: API_CALL
    private func fetchUserProfile(user: GithubUserEntity) {
        userProfileViewModel.fetchProfile(username: user.username ?? "")
        
        userProfileViewModel.dataFetchingSuccessHandler = {[weak self] in
            guard let user = self?.userProfileViewModel.data else {
                return
            }
            
            self?.showData(user: user)
            self?.saveData(userProfile: user)
        }
        
        userProfileViewModel.dataFetchingFailedHandler = { [weak self] in
            self?.showData(user: self?.githubUser?.asGithubUser ?? GithubUser())
        }
    }
    
    //When tap on save button
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        guard let user = githubUser else {
            return
        }
        
        //update user note to local db
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
            
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.ivProfilePicture.image = image?.decodedImage(size: weakSelf.ivProfilePicture.bounds.size)
            
            //Image can be late becasue of single queue image downloader
            ShimmerHelper.stopShimmerAnimation(view: weakSelf.ivProfilePicture)
        }
        
        // stop shimmer effect
        stopShimmerAnimation()
    }
    
    // save user profile data to local db
    private func saveData(userProfile: GithubUser) {
        guard let user = githubUser else {
            return
        }
        
        user.followers = Int64(userProfile.followers ?? 0)
        user.followings = Int64(userProfile.followings ?? 0)
        user.company = userProfile.company
        user.blog = userProfile.blog
        
        userProfileViewModel.updateUserEntity(user: user)
    }
    
    public func startShimmerAnimation() -> Void {
       //shmmer skeleton animation
        ShimmerHelper.startShimmerAnimation(view: ivProfilePicture)
        ShimmerHelper.startShimmerAnimation(view: lblFollowing)
        ShimmerHelper.startShimmerAnimation(view: lblFollwer)
        ShimmerHelper.startShimmerAnimation(view: uivInfoContainer)
        ShimmerHelper.startShimmerAnimation(view: lblTitleNote)
        ShimmerHelper.startShimmerAnimation(view: tvNote)
        ShimmerHelper.startShimmerAnimation(view: btnSave)
   }
       
   //stop shimmer animation
   public func stopShimmerAnimation() -> Void {
//    ShimmerHelper.stopShimmerAnimation(view: ivProfilePicture)
        ShimmerHelper.stopShimmerAnimation(view: lblFollwer)
        ShimmerHelper.stopShimmerAnimation(view: lblFollowing)
        ShimmerHelper.stopShimmerAnimation(view: uivInfoContainer)
        ShimmerHelper.stopShimmerAnimation(view: lblTitleNote)
        ShimmerHelper.stopShimmerAnimation(view: tvNote)
        ShimmerHelper.stopShimmerAnimation(view: btnSave)
   }
}
