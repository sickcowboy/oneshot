//
//  LoadingScreen.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-07.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class LoadingScreen: UIView {
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    let activityIndicator : UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aI.tintColor = Colors.sharedInstance.primaryTextColor
        aI.startAnimating()
        return aI
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(blur)
        blur.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        
        blur.contentView.addSubview(activityIndicator)
        activityIndicator.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: blur.centerXAnchor, centerY: blur.centerYAnchor, size: .init(width: 50, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
