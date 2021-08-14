//
//  GithubUserCellNote.swift
//  tawktestios
//
//  Created by JMC on 6/8/21.
//

import UIKit


class GithubUserCellNote: GithubUserCellNormal {
    internal let ivNote : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "ic_note"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.isSkeletonable = true 
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(ivNote)
        ivNote.anchor(top: containerView.topAnchor, left: lblDescription.rightAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 30, height: 30, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func configure(data: GithubUserCellNote.DataType) {
        super.configure(data: data)
    }
}
