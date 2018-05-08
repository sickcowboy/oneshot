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
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        
        button.tintColor = Colors.sharedInstance.primaryTextColor
        
        button.addTarget(self, action: #selector(challengePress), for: .touchUpInside)
        
        let attributedTitle = NSMutableAttributedString(string: "take the",
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        attributedTitle.append(NSAttributedString(string: "\nONE SHOT",
                                                  attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        attributedTitle.append(NSAttributedString(string: "\nCHALLENGE",
                                                  attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 44),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    lazy var challengeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.numberOfLines = 3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        let attributedTitle = NSMutableAttributedString(string: "todays challenge",
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        attributedTitle.append(NSAttributedString(string: "\nTAKE A PICTURE OF:",
                                                  attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        attributedTitle.append(NSAttributedString(string: "\n\(randomChallenge())",
                                                  attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 44),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        label.attributedText = attributedTitle
        
        return label
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
    
    fileprivate func randomChallenge() -> String {
        let rndNr = arc4random_uniform(UInt32(TemplateChallenges.sharedInstance.challenges.count))
        return TemplateChallenges.sharedInstance.challenges[Int(rndNr)]
    }
    
    fileprivate func setUp() {
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
    
    
    fileprivate func timeLeft() {
        let localTime = Date()
        guard let timeZone = TimeZone(abbreviation: "CET") else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.timeStyle = .full
        dateFormatter.dateStyle = .full
        
        let dateString = dateFormatter.string(from: localTime)
        guard let cetTime = dateFormatter.date(from: dateString) else { return }
        
        let calendar = Calendar.current
        
        guard let cetTomorrow = calendar.date(byAdding: .day, value: 1, to: cetTime) else { return }
        let cetExpireTime = calendar.startOfDay(for: cetTomorrow)
        
        let components = calendar.dateComponents([.hour, .minute, .second], from: cetTime, to: cetExpireTime)
        
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        countDownTimer.startCountDown(hours: hours, minutes: minutes, seconds: seconds)
    }
    
    @objc fileprivate func challengePress() {
        takeChallengeButton.isUserInteractionEnabled = false
        challengeLabel.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.takeChallengeButton.transform = CGAffineTransform(translationX: -30, y: 0)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.takeChallengeButton.transform = CGAffineTransform(translationX: -30, y: -100)
                self.takeChallengeButton.alpha = 0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.challengeLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.challengeLabel.alpha = 1
                }, completion: {_ in
                    self.segueToCamera()
                })
            })
        }
    }
    
    fileprivate func segueToCamera() {
        countDownTimer.stopCountDown()
        countDownTimer.startCountDown(hours: 0, minutes: 0, seconds: 3)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(CameraController(), animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        countDownTimer.stopCountDown()
    }
}
