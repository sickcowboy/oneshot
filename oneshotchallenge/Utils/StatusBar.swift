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
        let frame = UIApplication.shared.statusBarFrame
        let statusView = UIView()
        statusView.backgroundColor = Colors.sharedInstance.darkColor
        statusView.frame = frame
        view.addSubview(statusView)
//        statusView.constraintLayout(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil)
    }
}
