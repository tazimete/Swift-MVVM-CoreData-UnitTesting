//
//  TableViewCell.swift
//  tawktestios
//
//  Created by JMC on 26/7/21.
//

import UIKit

class GithubUserCellNormal : UITableViewCell, AbstractGithubCell {
    public var viewModel: AbstractCellViewModel?
    public static var cellReuseIdentifier: String = "GithubUserCell"
    private var imageUrlAtCurrentIndex: String?
    
    public var user : GithubUser? {
        didSet {
            imageUrlAtCurrentIndex = user?.avatarUrl
            lblUsername.text = user?.username
            lblDescription.text = user?.url
            containerView.backgroundColor = user?.isSeen ?? false ? .lightGray : .white
            ivAvatar.loadImage(from: user?.avatarUrl ?? "", completionHandler: {
                [weak self] url, image, isCache in
                
                guard let weakSelf = self else {
                    return
                }
                
                if (url).elementsEqual(weakSelf.imageUrlAtCurrentIndex ?? ""){
                    weakSelf.ivAvatar.image = image
                }
            })
        }
    }
    
    private let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let lblUsername : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let lblDescription : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let ivAvatar : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "img_avatar"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 45 
        return imgView
    }()
    
    override func prepareForReuse() {
        ivAvatar.image = nil
        lblUsername.text = ""
        lblDescription.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
        
        addSubview(containerView)
        containerView.addSubview(ivAvatar)
        containerView.addSubview(lblUsername)
        containerView.addSubview(lblDescription)
        
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: frame.width, height: 0, enableInsets: false)
        ivAvatar.anchor(top: containerView.topAnchor, left:  containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 90, enableInsets: false)
        lblUsername.anchor(top: containerView.topAnchor, left: ivAvatar.rightAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 15, width: frame.size.width, height: 0, enableInsets: false)
        lblDescription.anchor(top: lblUsername.bottomAnchor, left: ivAvatar.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 15, paddingRight: 15, width: frame.size.width, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(viewModel: AbstractCellViewModel) {
        imageUrlAtCurrentIndex = viewModel.thumbnail
        lblUsername.text = viewModel.title
        lblDescription.text = viewModel.subtitle
        ivAvatar.loadImage(from: viewModel.thumbnail ?? "", completionHandler: {
            [weak self] url, image, isCache in
            
            guard let weakSelf = self else {
                return
            }
            
            if (url).elementsEqual(weakSelf.imageUrlAtCurrentIndex ?? ""){
                weakSelf.ivAvatar.image = image
            }
        })
    }
}
