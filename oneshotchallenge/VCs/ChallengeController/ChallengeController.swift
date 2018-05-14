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
        return label
    }()
    
    let lockedLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.numberOfLines = 3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        let attributedTitle = NSMutableAttributedString(string: "Challenge done,",
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        attributedTitle.append(NSAttributedString(string: "\nnext challenge unlocks in:",
                                                  attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 44),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        label.attributedText = attributedTitle
        
        return label
    }()
    
    let countDownTimer = CountDownTimer()
    
    fileprivate let fbChallenges = FireBaseChallenges()
    fileprivate let fbPosts = FireBasePosts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkChallengeStatus()
    }
       
    fileprivate func setUpChallenge() {
        self.tabBarController?.tabBar.isHidden = false
        
        guard let bottomAnchor = tabBarController?.tabBar.topAnchor else { return }
        view.addSubview(countDownTimer)
        countDownTimer.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomAnchor,
                                        size: .init(width: 0, height: 80))
        
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
    
    fileprivate func setUpChallengeDone() {
        self.tabBarController?.tabBar.isHidden = false
        
        guard let bottomAnchor = tabBarController?.tabBar.topAnchor else { return }
        view.addSubview(countDownTimer)
        countDownTimer.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomAnchor,
                                        size: .init(width: 0, height: 80))
        
        view.addSubview(lockedLabel)
        lockedLabel.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, centerY: view.safeAreaLayoutGuide.centerYAnchor,
                                        padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 0))
    }
    
    fileprivate func checkChallengeStatus() {
        countDownTimer.removeFromSuperview()
        takeChallengeButton.removeFromSuperview()
        challengeLabel.removeFromSuperview()
        lockedLabel.removeFromSuperview()
        
        fbPosts.fetchPost { (post) in
            if let post = post {
                if post.imageUrl.isEmpty {
                    self.segueToCamera(post: post)
                } else {
                    self.setUpChallengeDone()
                }
            } else {
                self.fetchChallenge()
            }
            
            self.timeLeft()
        }
    }
    
    fileprivate let cetTime = CETTime()
    
    fileprivate func timeLeft() {
        guard let cetTimeNow = cetTime.timeNow() else { return }
        guard let cetExpireTime = cetTime.challengeTimeTomorrow() else { return }
        
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.hour, .minute, .second], from: cetTimeNow, to: cetExpireTime)
        
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        countDownTimer.startCountDown(hours: hours, minutes: minutes, seconds: seconds)
    }
    
    fileprivate func fetchChallenge() {
        debugPrint("fetchChallenge")
        fbChallenges.fetchChallenge { (challenge) in
            DispatchQueue.main.async {
                if let challenge = challenge {
                    debugPrint("Challenge found")
                    self.setChallengeLabelText(text: challenge)
                    self.setUpChallenge()
                } else {
                    debugPrint("Challenge not found")
                    self.setUpChallengeDone()
                }
            }
        }
    }
    
    fileprivate func setChallengeLabelText(text: String) {
        let attributedTitle = NSMutableAttributedString(string: "todays challenge",
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        attributedTitle.append(NSAttributedString(string: "\nTAKE A PICTURE OF:",
                                                  attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        attributedTitle.append(NSAttributedString(string: "\n\(text)",
            attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 44),
                         NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        challengeLabel.attributedText = attributedTitle
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
                    let fbPosts = FireBasePosts()
                    fbPosts.startPost()
                    
                    self.segueToCamera()
                })
            })
        }
    }
    
    fileprivate func segueToCamera(post: Post? = nil) {
        if post == nil {
            countDownTimer.stopCountDown()
            countDownTimer.startCountDown(hours: 0, minutes: 0, seconds: 3)
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(CameraController(), animated: true)
            }
        } else {
            let controller = CameraController()
            controller.post = post
            
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        countDownTimer.stopCountDown()
    }
}
