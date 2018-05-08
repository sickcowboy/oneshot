//
//  AddChallengeController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class AddChallengeController: UIViewController {
    let challengeTitle: UITextField = {
        let tF = UITextField()
        tF.setUp(placeholdertext: "Challenge")
        return tF
    }()
    
    lazy var datePicker: UIDatePicker = {
        let dP = UIDatePicker()
        dP.date = Date()
        dP.backgroundColor = Colors.sharedInstance.primaryColor
        dP.setValue(Colors.sharedInstance.primaryTextColor, forKey: "textColor")
        dP.datePickerMode = .date
        return dP
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("POST", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 52)
        button.tintColor = Colors.sharedInstance.primaryTextColor
        button.addTarget(self, action: #selector(postClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        view.addSubview(challengeTitle)
        challengeTitle.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil,
                                        padding: .init(top: 4, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 40))
        
        view.addSubview(datePicker)
        datePicker.constraintLayout(top: challengeTitle.bottomAnchor, leading: nil, trailing: nil, bottom: nil, centerX: view.centerXAnchor,
                                    padding: .init(top: 8, left: 8, bottom: 8, right: 0))
        
        view.addSubview(postButton)
        postButton.constraintLayout(top: datePicker.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil,
                                    padding: .init(top: 8, left: 8, bottom: 8, right: 0))
    }
    
    @objc fileprivate func postClicked() {
        guard let challengeDescription = challengeTitle.text else { return }
        let cetTime = CETTime()
        guard let challengeDate = cetTime.calendarChallengeDate(date: datePicker.date) else { return }
        
        let fbChallenges = FireBaseChallenges()
        fbChallenges.addChallenge(challenge: challengeDescription, date: challengeDate.timeIntervalSince1970)
    }
}
