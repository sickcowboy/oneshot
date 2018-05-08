//
//  CameraController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit
import AVKit

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    let capturePreviewView = UIView()
    let output = AVCapturePhotoOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    let challengeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    lazy var captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        
        button.layer.borderColor = Colors.sharedInstance.secondaryColor.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 35
        
        button.tintColor = Colors.sharedInstance.darkColor
        
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        
        return button
    }()
    
    let flashToggleButton = FlashToggleButton(type: .system)
    
    let countDownTimer = CountDownTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        fetchChallenge()
    }
    
    fileprivate func fetchChallenge() {
        let fbChallenges = FireBaseChallenges()
        fbChallenges.fetchChallenge { (challenge) in
            if let challenge = challenge {
                DispatchQueue.main.async {
                    self.challengeLabel.text = challenge
                    self.setUpViews()
                }
            } else {
                // TODO : Display error message
            }
        }
    }
    
    fileprivate func setUpViews() {
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
        
        view.addSubview(countDownTimer)
        countDownTimer.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                        size: .init(width: 0, height: 80))
        
        startCountDown()
        
        DispatchQueue.global(qos: .utility).async {
            self.setupCaptureSession()
        }
    }
    
    fileprivate func startCountDown() {
        countDownTimer.startCountDown(hours: 1, minutes: 0, seconds: 0)
    }
    
    func goToEditPhotoController(image: UIImage) {
        let controller = EditPhototController()
        controller.photo = image
        controller.countDownTimer = countDownTimer
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
