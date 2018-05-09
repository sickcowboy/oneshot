//
//  SettingsController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-07.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    private let logOffButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Tired of this? ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Log Out", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(presentLogOut), for: .touchUpInside)
        return button
    }()
    
    private let addChallenge: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Admin:  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Add challenge", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(toAddChallenge), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        view.addSubview(logOffButton)
        logOffButton.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 0, left: 8, bottom: 4, right: 8))
        
        checkIfUserIsAdmin()
    }
    
    fileprivate func checkIfUserIsAdmin() {
        let fbUser = FireBaseUser()
        fbUser.checkIfAdmin { (admin) in
            DispatchQueue.main.async {
                if admin {
                    self.addAdminTools()
                } else {
                   self.addChallenge.removeFromSuperview()
                }
            }
        }
    }
    
    fileprivate func addAdminTools() {
        view.addSubview(addChallenge)
        addChallenge.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: logOffButton.topAnchor, padding: .init(top: 0, left: 8, bottom: 4, right: 8))
    }
    
    @objc fileprivate func presentLogOut() {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure?", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let fbAuth = FireBaseAuth()
            fbAuth.logOut(completion: { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc fileprivate func toAddChallenge() {
        let controller = AddChallengeController()
        navigationController?.pushViewController(controller, animated: true)
    }
}