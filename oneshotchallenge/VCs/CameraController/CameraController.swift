//
//  CameraController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit
import AVKit

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, CountDownTimerDelegate {
    let capturePreviewView = UIView()
    let output = AVCapturePhotoOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var isOnBoarding = false
    var captureDevice: AVCaptureDevice?
    var captureSession: AVCaptureSession?
    
    let challengeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
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
    
    var post: Post?
    
    let flashToggleButton = FlashToggleButton(type: .system)
    
    let countDownTimer = CountDownTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        if isOnBoarding {
            challengeLabel.text = "Take a Selfie"
            setUpOnBoarding()
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(checkTimeAndStartCountDown),
                                                   name: .UIApplicationWillEnterForeground, object: nil)
            fetchChallenge()
            checkTimeAndStartCountDown()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    @objc fileprivate func checkTimeAndStartCountDown() {
        countDownTimer.stopCountDown()
        
        if post == nil {
            startCountDown()
            return
        }
        
        let calendar = Calendar.current
        
        let startDate = Date(timeIntervalSince1970: post!.startDate)
        guard let endDate = calendar.date(byAdding: .hour, value: 1, to: startDate) else { return }
        let nowDate = Date()
        
        let components = calendar.dateComponents([.hour, .minute, .second], from: nowDate, to: endDate)
        
        guard let hour = components.hour else { return }
        guard let minute = components.minute else { return }
        guard let second = components.second else { return }
        
        if (hour <= 0 && minute <= 0 && second <= 0) {
            timesUp()
            return
        }
        
        startCountDown(hour: hour, minute: minute, second: second)
    }
    
    fileprivate func fetchChallenge() {
        let fbChallenges = FireBaseChallenges()
        fbChallenges.fetchChallenge { (challenge) in
            if let challenge = challenge {
                DispatchQueue.main.async {
                    self.challengeLabel.text = challenge.description
                    self.setUpViews()
                }
            } else {
                let alertController = UIAlertController(title: "Ops!", message: "Something went wrong. Try Againg.", preferredStyle: .actionSheet)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.fetchChallenge()
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
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
        
        DispatchQueue.global(qos: .utility).async {
            self.setupCaptureSession()
        }
    }
    
    fileprivate func startCountDown(hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
        countDownTimer.delegate = self
        
        let hour = hour ?? 1
        let minute = minute ?? 0
        let second = second ?? 0
        
        countDownTimer.startCountDown(hours: hour, minutes: minute, seconds: second)
    }
    
    func goToEditPhotoController(image: UIImage) {
        let controller = EditPhototController()
        controller.photo = image
        controller.isOnBoarding = isOnBoarding
        debugPrint(post as Any)
        controller.post = post
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func timesUp() {
        navigationController?.popViewController(animated: true)
    }
}
