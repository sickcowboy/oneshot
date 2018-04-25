//
//  CountDownTimer.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class CountDownTimer: UIView {
    
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
            if minutes < 0 {
                hours -= 1
                minutes = 59
            }
            
            minuteLabel.attributedText = templateAttributedTitle(title: "minutes", value: minutes)
        }
    }
    
    var seconds: Int = 0 {
        didSet{
            if seconds < 0 {
                minutes -= 1
                seconds = 59
            }
            
            secondsLabel.attributedText = templateAttributedTitle(title: "seconds", value: seconds)
        }
    }
    
    var timer = Timer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(minuteLabel)
        minuteLabel.constraintLayout(top: topAnchor, leading: nil, trailing: nil, bottom: bottomAnchor, centerX: centerXAnchor,
                                     size: .init(width: 80, height: 0))
        
        addSubview(hourLabel)
        hourLabel.constraintLayout(top: topAnchor, leading: nil, trailing: minuteLabel.leadingAnchor, bottom: bottomAnchor,
                                   padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 80, height: 0))
        
        addSubview(secondsLabel)
        secondsLabel.constraintLayout(top: topAnchor, leading: minuteLabel.trailingAnchor, trailing: nil, bottom: bottomAnchor,
                                      padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 80, height: 0))
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
            attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 52),
                         NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        return attributedTitle
    }
    
    func startCountDown(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            self.seconds -= 1
        }
    }
    
    func stopCountDown() {
        timer.invalidate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
