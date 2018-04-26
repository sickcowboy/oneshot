//
//  FlashToggleButton.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-26.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class FlashToggleButton: UIButton {
    enum FlashImage {
        case on
        case off
        case auto
    }
    
    var flashImage = FlashImage.off
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = Colors.sharedInstance.primaryTextColor
        setImage(#imageLiteral(resourceName: "FlashOff"), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
    }
    
    func changeFlashSetting() {
        switch flashImage {
        case .on:
            setImage(#imageLiteral(resourceName: "FlashOff"), for: .normal)
            flashImage = .off
            return
        case .off:
            setImage(#imageLiteral(resourceName: "FlashAuto"), for: .normal)
            flashImage = .auto
            return
        case .auto:
            setImage(#imageLiteral(resourceName: "FlashOn"), for: .normal)
            flashImage = .on
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
