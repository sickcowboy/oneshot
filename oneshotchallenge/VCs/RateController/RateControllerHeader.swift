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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.textAlignment = .center
        return label
    }()
    
    let voteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var numberOfVotes: UInt? {
        didSet{
            guard let votes = numberOfVotes else { return }
            debugPrint(votes)
            let attributedTitle = NSMutableAttributedString(string: "Votes: ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            attributedTitle.append(NSAttributedString(string: "\n\(votes)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
            
            debugPrint(attributedTitle)
            voteLabel.attributedText = attributedTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerLabel)
        headerLabel.constraintLayout(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil,
                                     padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        addSubview(voteLabel)
        voteLabel.constraintLayout(top: headerLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil,
                                   padding: .init(top: 4, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
