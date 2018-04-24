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
    
    lazy var hourLabel: UILabel = {
        return templateTimeLabel()
    }()
    
    lazy var minuteLabel: UILabel = {
        return templateTimeLabel()
    }()
    
    lazy var secondsLabel: UILabel = {
       return templateTimeLabel()
    }()
    
    var hours: Int = 0 {
        didSet{
            hourLabel.attributedText = templateAttributedTitle(title: "hours", value: hours)
        }
    }
    
    var minutes: Int = 0 {
        didSet{
            if minutes < 1 {
                hours -= 1
                minutes = 60
            }
            
            minuteLabel.attributedText = templateAttributedTitle(title: "minutes", value: minutes)
        }
    }
    
    var seconds: Int = 0 {
        didSet{
            if seconds < 1 {
                minutes -= 1
                seconds = 60
            }

            secondsLabel.attributedText = templateAttributedTitle(title: "seconds", value: seconds)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        setUp()
        
        timeLeft()
    }
    
    fileprivate func setUp() {
        view.addSubview(takeChallengeButton)
        takeChallengeButton.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: view.centerXAnchor, centerY: view.centerYAnchor,
                                             size: .init(width: 0, height: 100))
        
        setUpTimerViews()
    }
    
    fileprivate func setUpTimerViews() {
        view.addSubview(minuteLabel)
        minuteLabel.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor,
                                     padding: .init(top: 0, left: 0, bottom: 16, right: 0))
        
        view.addSubview(hourLabel)
        hourLabel.constraintLayout(top: nil, leading: nil, trailing: minuteLabel.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   padding: .init(top: 0, left: 0, bottom: 16, right: 16))
        
        view.addSubview(secondsLabel)
        secondsLabel.constraintLayout(top: nil, leading: minuteLabel.trailingAnchor, trailing: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      padding: .init(top: 0, left: 16, bottom: 16, right: 0))
    }
    
    fileprivate func templateTimeLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    fileprivate func templateAttributedTitle(title: String, value: Int) -> NSMutableAttributedString {
        var valueString = ""
        
        if value < 10 {
            valueString = "0\(value)"
        } else {
            valueString = "\(value)"
        }
        
        let attributedTitle = NSMutableAttributedString(string: title,
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
                                                        NSAttributedStringKey.foregroundColor: Colors.sharedInstance.secondaryColor])
        attributedTitle.append(NSAttributedString(string: "\n\(valueString)",
            attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20),
                         NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        return attributedTitle
    }
    
    fileprivate func timeLeft() {
        let timeNow = Date()
        let calendar = Calendar.current
        
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: timeNow) else { return }
        let expireDate = calendar.startOfDay(for: tomorrow)
        
        let components = calendar.dateComponents([.hour, .minute, .second], from: timeNow, to: expireDate)
        
        hours = components.hour ?? 0
        minutes = components.minute ?? 0
        seconds = components.second ?? 0
        
        countDown()
    }
    
    fileprivate func countDown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.seconds -= 1
        })
    }
    
    @objc fileprivate func challengePress() {
        navigationController?.pushViewController(CameraController(), animated: true)
    }
}
