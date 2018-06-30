//
//  AddChallengeController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class AddChallengeController: UIViewController, UITextFieldDelegate {
    lazy var challengeTitle: UITextField = {
        let tF = UITextField()
        tF.delegate = self
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
    
    private let allChallengesButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "See all ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Challenges", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(toAllChallenges), for: .touchUpInside)
        return button
    }()
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
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
        
        
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.constraintLayout(top: datePicker.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,
                                           bottom: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 0))
        
        view.addSubview(allChallengesButton)
        allChallengesButton.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 0, left: 8, bottom: 4, right: 8))
    }
    
    @objc fileprivate func postClicked() {
        view.endEditing(true)
        guard let challengeDescription = challengeTitle.text else { return }
        let cetTime = CETTime()
        guard let challengeDate = cetTime.calendarChallengeDate(date: datePicker.date)?.timeIntervalSince1970 else { return }
        
        postButton.isHidden = true
        activityIndicator.startAnimating()
        
        let fbChallenges = FireBaseChallenges()
        fbChallenges.fetchChallenge(challengeDate: challengeDate) { (challenge) in
            if let challenge = challenge {
                DispatchQueue.main.async {
                    self.showError(challenge: challenge)
                }
                return
            }
            fbChallenges.addChallenge(challenge: challengeDescription, date: challengeDate, completion: { (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self.showError(error: error)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.showError()
                }
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postClicked()
        return true
    }
    
    fileprivate func showError(error: Error? = nil, challenge: Challenge? = nil) {
        activityIndicator.stopAnimating()
        postButton.isHidden = false
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        alertController.title = "Nice"
        alertController.message = "Nu är utmaningen redo"
        
        if let error = error {
            alertController.title = "Ojdå"
            alertController.message = error.localizedDescription
        }
        
        if let challenge = challenge {
            alertController.title = challenge.description
            alertController.message = "Finns redan tillagd på detta datum"
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func toAllChallenges() {
        let controller = AllChallengesVC()
        navigationController?.pushViewController(controller, animated: true)
    }
}
