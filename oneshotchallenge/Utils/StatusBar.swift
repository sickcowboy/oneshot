//
//  StatusBar.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-14.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class StausBar {
    static let sharedInstance = StausBar()
    
    func changeColor(view: UIView) {
        let statusView = UIView()
        statusView.backgroundColor = Colors.sharedInstance.darkColor
        
        view.addSubview(statusView)
        statusView.constraintLayout(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil,
                                    size: .init(width: 0, height: 20))
    }
}
