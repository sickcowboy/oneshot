//
//  LoginRegisterVC.swift
//  remotepush
//
//  Created by Dennis Galvén on 2018-03-01.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let topView: UILabel = {
        let label = UILabel()
        let attributedTitle = NSMutableAttributedString(string: "\nONE SHOT",
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor])
        
        attributedTitle.append(NSAttributedString(string: "\nCHALLENGE",
                                                  attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 44),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        
        label.attributedText = attributedTitle
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = Colors.sharedInstance.darkColor
        return label
    }()
    
    let emailTF: UITextField = {
        let tf = UITextField()
        tf.setUp(placeholdertext: "email")
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.returnKeyType = .next
        tf.addTarget(self, action: #selector(editChanged), for: .editingChanged)
        return tf
    }()
    
    let userNameTF: UITextField = {
        let tf = UITextField()
        tf.setUp(placeholdertext: "username")
        tf.returnKeyType = .next
        tf.addTarget(self, action: #selector(editChanged), for: .editingChanged)
        return tf
    }()
    
    let passwordTF: UITextField = {
        let tf = UITextField()
        tf.setUp(placeholdertext: "password")
        tf.returnKeyType = .done
        tf.addTarget(self, action: #selector(editChanged), for: .editingChanged)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(cgColor: Colors.sharedInstance.lightColor.cgColor)
        button.alpha = 0.4
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let toLoginButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.primaryTextColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.setTitleColor(Colors.sharedInstance.primaryColor, for: .normal)
        button.tintColor = Colors.sharedInstance.primaryColor
        button.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        view.addSubview(topView)
        topView.constraintLayout(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, centerX: nil, centerY: nil, size: .init(width: 0, height: 200))
        
        view.addSubview(toLoginButton)
        toLoginButton.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 5, right: 16), size: .init(width: 0, height: 40))
        
        setUpForm()
    }
    
    fileprivate func setUpForm() {
        emailTF.delegate = self
        userNameTF.delegate = self
        passwordTF.delegate = self
        
        let views = [emailTF, userNameTF, passwordTF, submitButton]
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.setUp(vertical: true, spacing: 8)
        
        view.addSubview(stackView)
        
        stackView.constraintLayout(top: topView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, centerX: nil, centerY: nil, padding: .init(top: 10, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 184))
    }
    
    @objc private func editChanged() {
        if (emailTF.text?.isEmpty ?? true ||
            userNameTF.text?.isEmpty ?? true ||
            passwordTF.text?.isEmpty ?? true) {
            submitButton.isEnabled = false
            submitButton.alpha = 0.4
        } else {
            submitButton.isEnabled = true
            submitButton.alpha = 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF:
            userNameTF.becomeFirstResponder()
            break
        case userNameTF:
            passwordTF.becomeFirstResponder()
            break
        case passwordTF:
            view.endEditing(true)
            break
        default:
            break
        }
        return true
    }
    
    @objc fileprivate func registerButtonClicked() {
        checkUserName()
    }

    fileprivate let fbRegister = FireBaseRegister()
    
    fileprivate func registerAccount() {
        guard let email = emailTF.text else { return }
        guard let password = passwordTF.text else { return }
        guard let username = userNameTF.text else { return }
        
        fbRegister.registerWithEmail(email: email, password: password, username: username) { (error) in
            self.activityIndication(loading: false)
            
            if let error = error {
                self.alert(message: error.localizedDescription)
                
                return
            }
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func checkUserName() {
        guard let username = userNameTF.text else { return }
        
        activityIndication(loading: true)
        
        fbRegister.checkIfUserNameExists(username: username) { (exists) in
            if exists {
                self.activityIndication(loading: false)
                
                self.userNameTF.text = ""
                
                self.alert(message: "Username already taken. Please try another one.")
            } else {
                self.registerAccount()
            }
        }
    }
    
    fileprivate func alert(message: String)  {
        let alertController = UIAlertController(title: "Ops!", message: message, preferredStyle: .actionSheet)
        alertController.oneAction()
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate let loadingScreen = LoadingScreen()
    
    fileprivate func activityIndication(loading: Bool) {
        if loading {
            view.addSubview(loadingScreen)
            loadingScreen.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            loadingScreen.removeFromSuperview()
        }
    }
    
    @objc private func toLogin() {
        navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
