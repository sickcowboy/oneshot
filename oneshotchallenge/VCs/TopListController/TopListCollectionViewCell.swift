//
//  TopListCollectionViewCell.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-14.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class TopListControllerCell: UICollectionViewCell {
    
    var placement: Int? {
        didSet{
            setStarColor()
        }
    }
    
    fileprivate let imageView: UIImageView = {
        let image = #imageLiteral(resourceName: "Star")
        let iV = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        iV.contentMode = .scaleAspectFit
        iV.clipsToBounds = true
        return iV
    }()
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Colors.sharedInstance.primaryTextColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.sharedInstance.primaryColor
        
        addSubview(imageView)
        imageView.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor,
                                   padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        imageView.squareByHeightAnchor()
        
        addSubview(nameLabel)
        nameLabel.constraintLayout(top: nil, leading: imageView.trailingAnchor, trailing: trailingAnchor, bottom: nil,
                                   centerY: imageView.centerYAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))
    }
    
    fileprivate func setStarColor() {
        guard let placement = placement else { return }
        
        nameLabel.text = String(placement)
        imageView.isHidden = false
        
        switch placement {
        case 0:
            imageView.tintColor = Colors.sharedInstance.goldColor
            return
        case 1:
            imageView.tintColor = Colors.sharedInstance.silverColor
            return
        case 2:
            imageView.tintColor = Colors.sharedInstance.bronzeColor
            return
        default:
            imageView.isHidden = true
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
