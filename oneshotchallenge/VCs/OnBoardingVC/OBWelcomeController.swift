//
//  WelcomeController.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-06-19.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class OBWelcomeController: UIViewController {
    
    let fbUser = FireBaseUser()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Welcome to",
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),
                                                                     NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedText.append(NSAttributedString(string: "\nOne Shot Challenge",
            attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 32),
                         NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))

        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        
        let appInfo = "1. Take a challenge, you have only one chance, one shot, to post a picture following the challenge theme of the day \n\n2. once a picture is taken, you need to vote on 5 pictures on yesterdays challenge to complete your entry into todays challenge \n\n3. When a challenge is completed and voted upon you will see the winning pictures and your result. "
        
        let attributedText = NSMutableAttributedString(string: "How to compete:",
                                                       attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24),
                                                                    NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        attributedText.append(NSAttributedString(string: "\n\n\(appInfo)",
                                                 attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
                                                              NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Let's try it!", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 28), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.sharedInstance.primaryColor
        title = "Tutorial"
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        fbUser.checkIfProfileImageExists { (imageExists) in
            guard let imageExists = imageExists else { return }
            
            DispatchQueue.main.async {
                if imageExists {
                    self.setUpView()
                    self.setUpGoToRating()
                    self.okButton.addTarget(self, action: #selector(self.goToRating), for: .touchUpInside)
                } else {
                    self.setUpView()
                    self.okButton.addTarget(self, action: #selector(self.goToChallenge), for: .touchUpInside)
                }
            }
        }
        
        let postProfileImageComplete = Notification.Name(NotificationNames.postProfileComplete.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileComplete), name: postProfileImageComplete, object: nil)
        
        let postVoteComplete = Notification.Name(NotificationNames.postVoteComplete.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(handleVoteComplete), name: postVoteComplete, object: nil)
    }
    
    private func setUpView() {
        
        view.addSubview(welcomeLabel)
        welcomeLabel.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 12, left: 4, bottom: 0, right: 4))
        
        view.addSubview(infoLabel)
        infoLabel.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, centerX: view.centerXAnchor, centerY: view.centerYAnchor , padding: .init(top: 0, left: 4, bottom: 0, right: 4))
        
        view.addSubview(okButton)
        okButton.constraintLayout(top: infoLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, padding: .init(top: 0, left: 4, bottom: 12, right: 4))
    }
    
    @objc private func goToChallenge() {
        let challengeController = ChallengeController()
        challengeController.isOnBoarding = true
        let challengeNavController = UINavigationController(rootViewController: challengeController)
        
        present(challengeNavController, animated: true, completion: nil)
    }
    
    @objc private func goToRating() {
        let rateController = RateControllerDeux()
        rateController.isOnBoarding = true
        
        self.present(rateController, animated: false, completion: nil)
    }
    
    @objc fileprivate func goToMainApp() {
        let mainTabBarVC = presentingViewController as! MainTabVC
        mainTabBarVC.setUpControllers()
        
        self.dismiss(animated: true, completion: nil)
    }

    fileprivate func setUpGoToRating() {
        let welcomeLabelTitle = "Great Work!"
        let welcomeLabelInfo = ""
        
        welcomeLabel.attributedText = setAttributedText(title: welcomeLabelTitle, titleSize: 32, info: welcomeLabelInfo, infoSize: 32)
        
        let infoLabelTitle = "Next thing you need to do is vote on 5 pictures to complete the challenge."
        let infoLabelinfo = "\n(For this tutorial it will only be dummy pictures)"
        
        infoLabel.attributedText = setAttributedText(title: infoLabelTitle, titleSize: 18, info: infoLabelinfo, infoSize: 18)
        
        let attributedTitle = NSMutableAttributedString(string: "Let's do it!", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 28), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        self.okButton.setAttributedTitle(attributedTitle, for: .normal)
        
        self.okButton.removeTarget(self, action: #selector(self.goToChallenge), for: .touchUpInside)
        
        self.okButton.addTarget(self, action: #selector(self.goToRating), for: .touchUpInside)
    }
    
    @objc private func handleProfileComplete(notification: NSNotification) {
        setUpGoToRating()
        
        self.presentedViewController?.dismiss(animated: false, completion: {
            self.animateUI()
        })
    }
    
    fileprivate func animateUI() {
        let x = view.frame.width
        welcomeLabel.transform = CGAffineTransform(translationX: x, y: 0)
        infoLabel.transform = CGAffineTransform(translationX: x, y: 0)
        okButton.transform = CGAffineTransform(translationX: x, y: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5,
                       options: .curveEaseOut, animations: {
                self.welcomeLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                self.infoLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                self.okButton.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    @objc private func handleVoteComplete(notification: NSNotification) {
        let fbUser = FireBaseUser()
        fbUser.setIsOnBoarded()
        
        let welcomeLabelTitle = "Great Work!"
        let welcomeLabelInfo = ""
        welcomeLabel.attributedText = setAttributedText(title: welcomeLabelTitle, titleSize: 32, info: welcomeLabelInfo, infoSize: 32)
        
        let infoLabelTitle = "You are now ready to compete in real challenges. Good luck!"
        let infoLabelinfo = ""
        infoLabel.attributedText = setAttributedText(title: infoLabelTitle, titleSize: 18, info: infoLabelinfo, infoSize: 18)
        
        let attributedTitle = NSMutableAttributedString(string: "I'm ready!", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 28), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        self.okButton.setAttributedTitle(attributedTitle, for: .normal)
        
        okButton.removeTarget(self, action: #selector(goToRating), for: .touchUpInside)
        
        okButton.addTarget(self, action: #selector(goToMainApp), for: .touchUpInside)
        
        self.presentedViewController?.dismiss(animated: false, completion: {
            self.animateUI()
        })
    }
    
    fileprivate func setAttributedText(title: String, titleSize: CGFloat, info: String, infoSize: CGFloat) -> NSMutableAttributedString {
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: titleSize),
                                                                                   NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        attributedText.append(NSAttributedString(string: info,
                                                 attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: infoSize),
                                                              NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        return attributedText
    }
}
