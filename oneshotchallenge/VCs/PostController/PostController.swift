//
//  PostController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit
import FirebaseStorage

class PostController: UIViewController, InfoViewDelegate {
    
    var isOnBoarding = false
    fileprivate let fbPosts = FireBasePosts()
    
    lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        
        let attributedTitle = NSMutableAttributedString(string: "POST",
                                                       attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 52),
                                                                    NSAttributedStringKey.foregroundColor: Colors.sharedInstance.darkColor])
        attributedTitle.append(NSAttributedString(string: "\npicture to enter challenge",
                                                  attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.secondaryColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.tintColor = Colors.sharedInstance.darkColor
        button.addTarget(self, action: #selector(postClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "I'll ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.secondaryColor])
        attributedTitle.append(NSAttributedString(string: "skip ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.darkColor]))
        attributedTitle.append(NSAttributedString(string: "this round", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: Colors.sharedInstance.secondaryColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(skipRound), for: .touchUpInside)
        
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back to edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = Colors.sharedInstance.secondaryColor
        
        button.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        return button
    }()
    
    let infoView = InfoView()
    
    var image: UIImage? {
        didSet{
           frameView.image = image
        }
    }
    
    let frameView = FramedPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.sharedInstance.lightColor
        
        if isOnBoarding {
            setUpOnBoarding()
        } else {
            setUpView()
        }
        
        infoView.delegate = self
    }
    
    fileprivate func setUpView() {
        view.addSubview(backButton)
        backButton.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: nil, bottom: nil,
                                    padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        
        view.addSubview(frameView)
        frameView.constraintLayout(top: backButton.bottomAnchor, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor,
                                   padding: .init(top: 16, left: 0, bottom: 0, right: 0),
                                   size: .init(width: view.frame.width - 50, height: view.frame.width - 50))
        
        view.addSubview(postButton)
        postButton.constraintLayout(top: frameView.bottomAnchor, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor,
                                    padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        view.addSubview(cancelButton)
        cancelButton.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.safeAreaLayoutGuide.centerXAnchor,
                                      padding: .init(top: 16, left: 0, bottom: 4, right: 0))
        
        if isOnBoarding {
            backButton.isHidden = true
            backButton.isEnabled = false
            cancelButton.isHidden = true
            cancelButton.isEnabled = false
        }
    }
    
    @objc fileprivate func postClicked() {
        guard let image = image else { return }

        activityIndication(loading: true)

        if !isOnBoarding {
            fbPosts.uploadPost(image: image, completion: { error in
                DispatchQueue.main.async {
                    self.activityIndication(loading: false)
                    
                    if let error = error {
                        self.showError(description: error.localizedDescription)
                        return
                    }
                    
                    self.showInfoWindow()
                }
            })
        } else {
            let fbUser = FireBaseUser()
            fbUser.uploadProfilePic(image: image) { (error) in
                DispatchQueue.main.async {
                    self.activityIndication(loading: false)
                    if let error = error {
                        self.showError(description: error.localizedDescription)
                        return
                    }
                    let postProfileImageComplete = Notification.Name(NotificationNames.postProfileComplete.rawValue)
                    NotificationCenter.default.post(name: postProfileImageComplete, object: nil)
                }
            }
        }
    }
    
    @objc fileprivate func skipRound() {
        let alertController = UIAlertController(title: "Are you sure?", message: "This will remove you from this challenge.", preferredStyle: .actionSheet)
        let oneAction = UIAlertAction(title: "I'm sure", style: .destructive) { (_) in
            self.activityIndication(loading: true)
            self.fbPosts.dismissPost(completion: { (complete) in
                debugPrint(complete)
                if complete {
                    DispatchQueue.main.async {
                        self.activityIndication(loading: false)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            })
        }
        let twoAction = UIAlertAction(title: "I'll think about it", style: .default, handler: nil)
        
        alertController.addAction(oneAction)
        alertController.addAction(twoAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func showError(description: String) {
        self.alert(message: description)
        self.cancelButton.isHidden = false
        self.backButton.isHidden = false
        self.postButton.isHidden = false
    }
    
    fileprivate func showInfoWindow() {
        infoView.removeFromSuperview()
        
        view.addSubview(infoView)
        infoView.constraintLayout(top: postButton.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
        infoView.setText(text: "Please remember, to complete the challenge you also need to vote.")
        
        animateDone()
    }
    
    func animateDone() {
        infoView.transform = CGAffineTransform(translationX: 300, y: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.infoView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    @objc func backClick() {
        navigationController?.popViewController(animated: true)
    }
    

    fileprivate let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    fileprivate func activityIndication(loading: Bool) {
        activityIndicator.color = Colors.sharedInstance.darkColor
        
        activityIndicator.removeFromSuperview()
        
        cancelButton.isHidden = true
        backButton.isHidden = true
        postButton.isHidden = true
        
        if loading {
            view.addSubview(activityIndicator)
            activityIndicator.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: postButton.centerXAnchor, centerY: postButton.centerYAnchor)
            activityIndicator.squareByHeightAnchor()
            
            activityIndicator.startAnimating()
        }
    }
    
    fileprivate func alert(message: String)  {
        let alertController = UIAlertController(title: "Ops!", message: message, preferredStyle: .actionSheet)
        alertController.oneAction()
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func okClick() {
        self.tabBarController?.selectedIndex = 1
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func shareClick() {
        let mergedImage = frameView.mergedImage()
        let shareActivity = ShareActivity()
        shareActivity.share(image: mergedImage, viewController: self, view: view)
    }
}
