//
//  CameraControllerOnBoarding.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-06-23.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

extension CameraController {
    
    func setUpOnBoarding() {
        view.addSubview(challengeLabel)
        challengeLabel.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil,
                                        padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        
        view.addSubview(capturePreviewView)
        capturePreviewView.constraintLayout(top: challengeLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil,
                                            padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        capturePreviewView.squareByWidthAnchor()
        
        view.addSubview(captureButton)
        captureButton.constraintLayout(top: capturePreviewView.bottomAnchor, leading: nil, trailing: nil, bottom: nil, centerX: view.centerXAnchor,
                                       padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 70, height: 70))
        
        view.addSubview(flashToggleButton)
        flashToggleButton.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: nil, bottom: nil, centerY: captureButton.centerYAnchor,
                                           padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 35, height: 35))
        /*
        view.addSubview(countDownTimer)
        countDownTimer.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                        size: .init(width: 0, height: 80)) */
        
        DispatchQueue.global(qos: .utility).async {
            self.setupCaptureSession()
        }
    }
}
