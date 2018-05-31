//
//  InfoView.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-31.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class InfoView: UIView {
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.sharedInstance.primaryColor
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.primaryTextColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(blur)
        blur.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        
        blur.addSubview(contentView)
        contentView.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: centerXAnchor, centerY: centerYAnchor,
                                     size: .init(width: frame.width - 16, height: frame.width - 16))
    }
    
    fileprivate func animate() {
        contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        contentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.contentView.alpha = 1
        }) { (_) in
            // TODO : Activate buttons
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
