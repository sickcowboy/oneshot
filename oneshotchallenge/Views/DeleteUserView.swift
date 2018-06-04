//
//  ReAuthenticateUserView.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-06-01.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DeleteUserView: UIView {
    
    let currentUser = Auth.auth().currentUser
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var naviController: UINavigationController?
    
    func getNavController(navi: UINavigationController) {
        naviController = navi
    }
    
    let contentView : UIView = {
        let view = UIView()
        view.backgroundColor = Colors.sharedInstance.lightColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.darkColor
        label.backgroundColor = Colors.sharedInstance.lightColor
        label.text = "Authenticate User:"
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let passwordTF: UITextField = {
        let tf = UITextField()
        tf.setUp(placeholdertext: "password")
        tf.returnKeyType = .done
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(editChanged), for: .editingChanged)
        return tf
    }()
    
    let okButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ok", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(cgColor: Colors.sharedInstance.secondaryColor.cgColor)
        button.alpha = 0.4
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleOk), for: .touchUpInside)
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(cgColor: Colors.sharedInstance.secondaryColor.cgColor)
        button.alpha = 1
        button.layer.cornerRadius = 5
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height/3
        
        addSubview(blur)
        blur.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        
        blur.contentView.addSubview(contentView)
        contentView.constraintLayout(top: nil, leading: blur.leadingAnchor, trailing: blur.trailingAnchor, bottom: nil, centerX: nil, centerY: blur.centerYAnchor, padding: .init(top: 0, left: 12, bottom: 12, right: 12), size: .init(width: 0, height: screenHeight))
        
        setUpStack()
    }
    
    fileprivate func setUpStack() {
        
        guard let userEmail = currentUser?.email else { return }
        emailLabel.text = userEmail
        
        let views = [titleLabel, emailLabel, passwordTF, okButton, cancelButton]
        
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        stackView.constraintLayout(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    @objc fileprivate func handleOk() {
        reAuthUser()
    }
    
    @objc fileprivate func handleCancel() {
        removeFromSuperview()
    }
    
    @objc func editChanged() {
        if (passwordTF.text?.isEmpty ?? true) {
            okButton.isEnabled = false
            okButton.alpha = 0.4
        } else {
            okButton.isEnabled = true
            okButton.alpha = 1
        }
    }
    
    fileprivate func reAuthUser() {
        
        guard let userPassword = passwordTF.text else { return }
        guard let userEmail = currentUser?.email else { return }
        
        let userProfile = EmailAuthProvider.credential(withEmail: userEmail, password: userPassword)
    
        Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: userProfile, completion: { (result, error) in
            
            if let error = error {
                let alertController = UIAlertController(title: "Ops!", message: error.localizedDescription, preferredStyle: .alert)
                alertController.oneAction()
                
                alertController.show()
                return
            }
            
            self.displayAlert()
            self.removeFromSuperview()
        })
    }
    
    fileprivate func displayAlert() {
        let alertController = UIAlertController(title: "Warning", message: "You are about to delete your profile. Continue?", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            guard let user = self.currentUser else { return }
            let userRef = Database.database().reference(withPath: DatabaseReference.users.rawValue)
            let uid = user.uid
            
            let value: [String: Any] = [DatabaseReference.username.rawValue: "DeletedUser", DatabaseReference.profileDeleteDate.rawValue: Date().timeIntervalSince1970]
            
            userRef.child(uid).updateChildValues(value, withCompletionBlock: { (error, _) in
                
                if let error = error {
                    debugPrint("ERROR:  \(error)")
                } else {
                    debugPrint("delete user data completed")
                    self.deleteCurrentUser()
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        alertController.show()
    }
    
    fileprivate func deleteCurrentUser() {
        
        guard let user = currentUser else { return }
        
        let fbDeleteUser = FireBaseDeleteUser()
        
        fbDeleteUser.deleteCurrentUser(user: user) { (error) in
            if let error = error {
                let alertController = UIAlertController(title: "Ops!", message: error.localizedDescription, preferredStyle: .alert)
                
                alertController.oneAction()
                alertController.show()
                return
            } else {
                
                let alertController = UIAlertController(title: "Success", message: "Your account is now deleted", preferredStyle: .alert)
                
                alertController.oneAction()
                alertController.show()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
