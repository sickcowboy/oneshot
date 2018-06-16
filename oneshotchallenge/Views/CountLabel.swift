//
//  CountLabel.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-06-16.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class CountLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        numberOfLines = 0
    }
    
    func countTo(number: Int?){
        guard let number = number else { return }
        let attributedTitle = NSMutableAttributedString(string: "Votes left: ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "\n\(number)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        attributedText = attributedTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
