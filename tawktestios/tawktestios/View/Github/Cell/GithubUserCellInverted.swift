//
//  GithubUserCellInverted.swift
//  tawktestios
//
//  Created by JMC on 6/8/21.
//

import UIKit

class GithubUserCellInverted: GithubUserCellNormal {
    internal let lblType : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.text = "Inverted"
        lbl.isSkeletonable = true 
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(lblType)
        lblType.anchor(top: containerView.topAnchor, left: lblUsername.rightAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 50, height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func configure(data: GithubUserCellInverted.DataType) {
        imageUrlAtCurrentIndex = data.thumbnail
        lblUsername.text = data.title
        lblDescription.text = data.subtitle
        containerView.backgroundColor = data.isSeen ?? false ? .lightGray : .white
        ivAvatar.loadImage(from: data.thumbnail ?? "", completionHandler: {
            [weak self] url, image, isCache in

            guard let weakSelf = self else {
                return
            }

            if (url).elementsEqual(weakSelf.imageUrlAtCurrentIndex ?? ""){
                var invertedImage: UIImage?

                DispatchQueue.global(qos: .userInitiated).async {
                    invertedImage = image?.invertedImage()

                    DispatchQueue.main.async {
                        weakSelf.ivAvatar.image = invertedImage
                    }
                }
            }
        })
    }
}
