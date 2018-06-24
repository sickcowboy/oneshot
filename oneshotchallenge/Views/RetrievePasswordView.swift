//
//  File.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-05-31.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class RetrievePasswordView: UIView {
    
    func setEmail(email: String) {
        emailTF.text = email
        editChanged()
    }
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    let contentView : UIView = {
        let view = UIView()
        view.backgroundColor = Colors.sharedInstance.lightColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    let emailTF : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = Colors.sharedInstance.secondaryColor
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.becomeFirstResponder()
        tf.textColor = Colors.sharedInstance.darkColor
        tf.setUp(placeholdertext: "email")
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
        button.addTarget(self, action: #selector(goToChallenge), for: .touchUpInside)
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
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.darkColor
        label.backgroundColor = Colors.sharedInstance.lightColor
        label.text = "Retrieve Password"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height/4
        
        addSubview(blur)
        blur.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        
        blur.contentView.addSubview(contentView)
        contentView.constraintLayout(top: nil, leading: blur.leadingAnchor, trailing: blur.trailingAnchor, bottom: nil, centerX: nil, centerY: blur.centerYAnchor, padding: .init(top: 0, left: 12, bottom: 12, right: 12), size: .init(width: 0, height: screenHeight))
        
        setUpStack()
    }
    
    func setUpStack() {
        
        let views = [titleLabel, emailTF, okButton, cancelButton]
        
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        contentView.addSubview(stackView)
        stackView.constraintLayout(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor, centerX: nil, centerY: nil, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    @objc func handleOk() {
        
        let fbRetrievePassword = FireBaseRetrievePassword()
        
        guard let email = emailTF.text else { return }
        
        fbRetrievePassword.retrieveFBPassword(email: email) { (error) in
            
            if let error = error {
                let alertController = UIAlertController(title: "Ops!", message: error.localizedDescription, preferredStyle: .alert)
                alertController.oneAction()
                
                alertController.show()
                return
            }
            
            let alertController = UIAlertController(title: "Retrieve Password", message: "Password being sent to: \n \(email)", preferredStyle: .alert)
            
            alertController.oneAction()
            alertController.show()
            
            self.removeFromSuperview()
        }
    }
    
    @objc func handleCancel() {
        removeFromSuperview()
    }
    
    @objc func editChanged() {
        if (emailTF.text?.isEmpty ?? true) {
            okButton.isEnabled = false
            okButton.alpha = 0.4
        } else {
            okButton.isEnabled = true
            okButton.alpha = 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
