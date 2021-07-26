//
//  TableViewCell.swift
//  tawktestios
//
//  Created by JMC on 26/7/21.
//

import UIKit

class GithubUserCell : UITableViewCell {
    
    var user : GithubUser? {
        didSet {
//            productImage.image = user?.username
            productNameLabel.text = user?.username
            productDescriptionLabel.text = user?.username
        }
    }
    
    private let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let productNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let productDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let productImage : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "img_avatar"))
        imgView.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
        
        addSubview(containerView)
        containerView.addSubview(productImage)
        containerView.addSubview(productNameLabel)
        containerView.addSubview(productDescriptionLabel)
        
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: frame.width, height: 0, enableInsets: false)
        productImage.anchor(top: containerView.topAnchor, left:  containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        productNameLabel.anchor(top: containerView.topAnchor, left: productImage.rightAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 15, width: frame.size.width, height: 0, enableInsets: false)
        productDescriptionLabel.anchor(top: productNameLabel.bottomAnchor, left: productImage.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 15, paddingRight: 15, width: frame.size.width, height: 0, enableInsets: false)    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
