//
//  RateControllerHeader.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-06-13.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class RateControllerHeader: UICollectionViewCell {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "You're voting on Yesterdays challenge:", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedText.append(NSAttributedString(string: "\nA Challenge", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    /**let attributedTitle = NSMutableAttributedString(string: "Admin:  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
     attributedTitle.append(NSAttributedString(string: "Add challenge", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerLabel)
        headerLabel.constraintLayout(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
