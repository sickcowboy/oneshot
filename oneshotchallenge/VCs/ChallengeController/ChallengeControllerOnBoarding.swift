//
//  ChallengeControllerOnBoarding.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-06-23.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

extension ChallengeController {
 
    func setUpOnBoarding() {
        
        self.tabBarController?.tabBar.isHidden = false
        
        view.addSubview(takeChallengeButton)
        takeChallengeButton.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: view.centerXAnchor, centerY: view.safeAreaLayoutGuide.centerYAnchor,
                                             size: .init(width: 0, height: 0))
        
        view.addSubview(challengeLabel)
        challengeLabel.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, centerY: view.safeAreaLayoutGuide.centerYAnchor,
                                        padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 0))
        
        challengeLabel.isHidden = true
        challengeLabel.alpha = 0
        challengeLabel.transform = CGAffineTransform(translationX: 200, y: 0)
    }
    
    func segueToCameraOnBoarding(post: Post? = nil) {
        debugPrint("seguetocameraOnBoarding")
        let controller = CameraController()
        controller.isOnBoarding = true
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
            self.tabBarController?.tabBar.isHidden = true
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
