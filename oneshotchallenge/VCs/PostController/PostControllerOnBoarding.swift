//
//  PostControllerOnBoarding.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-06-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

extension PostController {
    
    func setUpOnBoarding() {
        
        view.addSubview(backButton)
        backButton.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: nil, bottom: nil,
                                    padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        backButton.isHidden = true
        backButton.isEnabled = false
        
        view.addSubview(frameView)
        frameView.constraintLayout(top: backButton.bottomAnchor, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor,
                                   padding: .init(top: 16, left: 0, bottom: 0, right: 0),
                                   size: .init(width: view.frame.width - 50, height: view.frame.width - 50))
        
        view.addSubview(postButton)
        postButton.constraintLayout(top: frameView.bottomAnchor, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor,
                                    padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        view.addSubview(cancelButton)
        cancelButton.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.safeAreaLayoutGuide.centerXAnchor,
                                      padding: .init(top: 16, left: 0, bottom: 4, right: 0))
        cancelButton.isHidden = true
        cancelButton.isEnabled = false
    }
    
    func showOnBoardingInfoView() {
        infoView.removeFromSuperview()
        
        view.addSubview(infoView)
        infoView.constraintLayout(top: postButton.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
        infoView.setText(text: "The last thing you need to do is vote on 10 pictures to complete the challenge")
        
        animateDone()
    }
}
