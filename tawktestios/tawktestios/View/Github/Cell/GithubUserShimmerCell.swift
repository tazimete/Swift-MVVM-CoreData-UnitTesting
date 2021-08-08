//
//  GithubUserShimmerCell.swift
//  tawktestios
//
//  Created by JMC on 7/8/21.
//

import UIKit


class GithubUserShimmerCell: GithubUserCellNormal {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func configure(data: GithubUserShimmerCell.DataType) {
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.clear.cgColor
        
        //shmmer skeleton animation
        let gradient = SkeletonGradient(baseColor: UIColor.lightGray)
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)

        lblUsername.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        lblDescription.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        ivAvatar.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
    }
}
