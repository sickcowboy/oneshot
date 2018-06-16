//
//  SettingsController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-07.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit
import FirebaseAuth

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
    
    private let debugDeleteVotes: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Debug:  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Reset votes", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(deleteUserVotes), for: .touchUpInside)
        return button
    }()
    
    private let debugResetUserPost: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Debug:  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Reset post", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(deleteUserPost), for: .touchUpInside)
        return button
    }()
    
    private lazy var buildLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.textAlignment = .center
        if let releaseVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                label.text = "build: \(releaseVersion) (\(buildVersion))"
            }
        }
        return label
    }()
    
    private let deleteUserButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Want to stop playing? ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Delete User", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(ReAuthenticateUser), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        view.addSubview(buildLabel)
        buildLabel.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil,
                                    padding: .init(top: 4, left: 4, bottom: 0, right: 4))
        
        view.addSubview(debugDeleteVotes)
        debugDeleteVotes.constraintLayout(top: buildLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,
                                          bottom: nil, padding: .init(top: 4, left: 4, bottom: 0, right: 4))
        
        view.addSubview(debugResetUserPost)
        debugResetUserPost.constraintLayout(top: debugDeleteVotes.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 4, left: 4, bottom: 0, right: 4))

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
    
    @objc func ReAuthenticateUser() {
        
        let reAuthUser = DeleteUserView()
        
        guard let navController = self.navigationController else { return }
        reAuthUser.getNavController(navi: navController)
        
        view.addSubview(reAuthUser)
        reAuthUser.constraintLayout(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
    }
    
    @objc fileprivate func toAddChallenge() {
        let controller = AddChallengeController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Debug options
    @objc fileprivate func deleteUserVotes() {
        FBDebug.sharedInstance.deleteUserVotes()
    }
    
    @objc fileprivate func deleteUserPost() {
        FBDebug.sharedInstance.deletePost()
    }
}
