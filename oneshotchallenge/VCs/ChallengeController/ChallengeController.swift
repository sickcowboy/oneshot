//
//  ChallengeController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class ChallengeController: UIViewController, CountDownTimerDelegate {
    var isOnBoarding = false
    
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
    
    let activityIndicator: UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aI.tintColor = Colors.sharedInstance.primaryTextColor
        aI.hidesWhenStopped = true
        return aI
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
    
    lazy var countDownTimer : CountDownTimer = {
        let cT = CountDownTimer()
        cT.delegate = self
        return cT
    }()
    
    fileprivate let fbChallenges = FireBaseChallenges()
    fileprivate let fbPosts = FireBasePosts()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StausBar.sharedInstance.changeColor(view: view)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        tabBarController?.tabBar.isHidden = true
        
        view.addSubview(activityIndicator)
        activityIndicator.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil,
                                           centerX: view.safeAreaLayoutGuide.centerXAnchor,
                                           centerY: view.safeAreaLayoutGuide.centerYAnchor)
        activityIndicator.stopAnimating()
        
        if isOnBoarding {
            self.setChallengeLabelText(text: ("Yourself"))
            self.setUpOnBoarding()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isOnBoarding {
            checkChallengeStatus()
            NotificationCenter.default.addObserver(self, selector: #selector(backFromBackground),
                                                   name: .UIApplicationWillEnterForeground, object: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        countDownTimer.stopCountDown()
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Challenge functions
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
    
    fileprivate func setUpChallengeDone(timesUp: Bool = false) {
        activityIndicator.stopAnimating()
        
        self.tabBarController?.tabBar.isHidden = false
        
        guard let bottomAnchor = tabBarController?.tabBar.topAnchor else { return }
        view.addSubview(countDownTimer)
        countDownTimer.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomAnchor,
                                        size: .init(width: 0, height: 80))
        
        view.addSubview(lockedLabel)
        lockedLabel.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, centerY: view.safeAreaLayoutGuide.centerYAnchor,
                                        padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 0))
        
        if timesUp {
            lockedLabel.attributedText = setLockedLabelText(text: "The train has left the station,", bigText: "another one will arrive in:")
            timeLeft()
            return
        }
        
        lockedLabel.attributedText = setLockedLabelText(text: "Challenge done,", bigText: "next challenge unlocks in:")
    }
    
    fileprivate func setLockedLabelText(text: String, bigText: String) -> NSMutableAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(text)",
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        attributedTitle.append(NSAttributedString(string: "\n\(bigText)",
                                                  attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 44),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        return attributedTitle
    }
    
    @objc fileprivate func backFromBackground() {
        checkChallengeStatus()
    }
    
    fileprivate func checkChallengeStatus() {
        countDownTimer.removeFromSuperview()
        takeChallengeButton.removeFromSuperview()
        challengeLabel.removeFromSuperview()
        lockedLabel.removeFromSuperview()
        
        activityIndicator.startAnimating()
        
        countDownTimer.stopCountDown()
        
        fbPosts.fetchPost { (post) in
            DispatchQueue.main.async {
                if let post = post {
                    if post.dismissed {
                        self.setUpChallengeDone(timesUp: true)
                        return
                    }
                    
                    if post.imageUrl.isEmpty {
                        self.activityIndicator.stopAnimating()
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
        fbChallenges.fetchChallenge { (challenge) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let challenge = challenge {
                    self.setChallengeLabelText(text: challenge.description)
                    self.setUpChallenge()
                } else {
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
            self.takeChallengeButton.transform = CGAffineTransform(translationX: 0, y: -100)
            self.takeChallengeButton.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.challengeLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                self.challengeLabel.alpha = 1
            }, completion: {_ in
                
                if self.isOnBoarding {
                    self.segueToCameraOnBoarding()
                } else {
                    let fbPosts = FireBasePosts()
                    fbPosts.startPost()
                    self.segueToCamera()
                }
            })
        })
    }
    
    fileprivate func segueToCamera(post: Post? = nil) {
        if post == nil {
            countDownTimer.stopCountDown()
            countDownTimer.startCountDown(hours: 0, minutes: 0, seconds: 3)
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                self.tabBarController?.tabBar.isHidden = true
                
                let postDictionary: [String: Any] = [DatabaseReference.startDate.rawValue: Date().timeIntervalSince1970]
                let newPost = Post(dictionary: postDictionary, userId: "")
                
                let controller = CameraController()
                controller.post = newPost
                
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            checkIfTimesLeft(post: post)
        }
    }
    
    fileprivate func checkIfTimesLeft(post: Post?) {
        guard let post = post else { return }
        
        let postDate = Date(timeIntervalSince1970: post.startDate)
        
        let calendar = Calendar.current
        
        guard let endDate = calendar.date(byAdding: .hour, value: 1, to: postDate) else { return }
        let difference = calendar.dateComponents([.hour, .minute, .second], from: Date(), to: endDate)
        
        guard let hour = difference.hour else { return }
        guard let minute = difference.minute else { return }
        guard let second = difference.second else { return }
        
        if hour <= 0 && minute <= 0 && second <= 0 {
            setUpChallengeDone(timesUp: true)
        } else {
            let controller = CameraController()
            controller.post = post
            
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    func timesUp() {
        countDownTimer.stopCountDown()
        checkChallengeStatus()
    }
}
