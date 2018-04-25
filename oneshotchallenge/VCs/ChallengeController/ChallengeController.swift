//
//  ChallengeController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class ChallengeController: UIViewController {
    
    lazy var takeChallengeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("TAKE CHALLENGE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.tintColor = Colors.sharedInstance.primaryTextColor
        button.addTarget(self, action: #selector(challengePress), for: .touchUpInside)
        return button
    }()
    
    let countDownTimer = CountDownTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        
        countDownTimer.removeFromSuperview()
        
        view.addSubview(countDownTimer)
        countDownTimer.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                        size: .init(width: 0, height: 80))
        
        timeLeft()
    }
    
    fileprivate func setUp() {
        view.addSubview(takeChallengeButton)
        takeChallengeButton.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor, centerY: view.centerYAnchor,
                                             size: .init(width: 0, height: 100))
    }
    
    fileprivate func timeLeft() {
        let timeNow = Date()
        let calendar = Calendar.current
        
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: timeNow) else { return }
        let expireDate = calendar.startOfDay(for: tomorrow)
        
        let components = calendar.dateComponents([.hour, .minute, .second], from: timeNow, to: expireDate)
        
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        countDownTimer.startCountDown(hours: hours, minutes: minutes, seconds: seconds)
    }
    
    @objc fileprivate func challengePress() {
        countDownTimer.stopCountDown()
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(CameraController(), animated: true)
    }
}
