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
        disableKeyboard(tappingView: view)
        ivProfilePicture.contentMode = .scaleAspectFill
        
        //init data
        self.tvNote.text = githubUser?.note
        self.lblFollwer.text = "Followers : \(githubUser?.followers ?? 0)"
        self.lblFollowing.text = "Follwings : \(githubUser?.followings ?? 0)"
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
            self?.saveData(userProfile: user)
        }
        
        userProfileViewModel.dataFetchingFailedHandler = { [weak self] in
            self?.showData(user: self?.githubUser?.asGithubUser ?? GithubUser())
            self?.stopShimmerAnimation()
        }
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
            
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.ivProfilePicture.image = image?.decodedImage(size: weakSelf.ivProfilePicture.bounds.size)
            weakSelf.stopShimmerAnimation()
        }
    }
    
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
       let gradient = SkeletonGradient(baseColor: UIColor.lightGray)
       let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)

        ivProfilePicture.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        lblFollowing.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        lblFollwer.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        ivProfilePicture.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        uivInfoContainer.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        lblTitleNote.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        tvNote.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        btnSave.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
   }
       
   //stop shimmer animation
   public func stopShimmerAnimation() -> Void {
        ivProfilePicture.hideSkeleton()
        lblFollwer.hideSkeleton()
        lblFollowing.hideSkeleton()
        uivInfoContainer.hideSkeleton()
        lblTitleNote.hideSkeleton()
        tvNote.hideSkeleton()
        btnSave.hideSkeleton()
   }
}
