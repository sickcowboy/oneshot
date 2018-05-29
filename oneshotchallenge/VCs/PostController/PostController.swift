//
//  PostController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class PostController: UIViewController {
    lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("POST", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 52)
        button.tintColor = Colors.sharedInstance.darkColor
        button.addTarget(self, action: #selector(postClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("I'll skip this round", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = Colors.sharedInstance.secondaryColor
        return button
    }()
    
    var image: UIImage? {
        didSet{
           frameView.image = image
        }
    }
    
    let frameView = FramedPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.sharedInstance.lightColor
        
        view.addSubview(frameView)
        frameView.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor, centerY: view.safeAreaLayoutGuide.centerYAnchor,
                                   size: .init(width: view.frame.width - 50, height: view.frame.width - 50))
        
        view.addSubview(postButton)
        postButton.constraintLayout(top: frameView.bottomAnchor, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor,
                                    padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        
        view.addSubview(cancelButton)
        cancelButton.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: nil, bottom: nil,
                                      padding: .init(top: 8, left: 8, bottom: 0, right: 0))
    }
    
    @objc fileprivate func postClicked() {
        guard let image = image else { return }
        postButton.isEnabled = false
        
        activityIndication(loading: true)
        
        let fbPosts = FireBasePosts()
        fbPosts.uploadPost(image: image, completion: { error in
            DispatchQueue.main.async {
                self.activityIndication(loading: false)
                
                if let error = error {
                    self.alert(message: error.localizedDescription)
                    self.postButton.isEnabled = true
                    return
                }
                //TODO : display to user that upload is succesful
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    fileprivate func shareWithSocialMedia(image: UIImage) {
        
        let imageText = "#OneShotChallenge"
        
        let activityController = UIActivityViewController(activityItems: [image, imageText], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceRect = view.bounds
        
        activityController.completionWithItemsHandler = { activity, success, items, error in
            print("activity: \(String(describing: activity)), success: \(success), items: \(String(describing: items)), error: \(String(describing: error))")
            
            if let error = error {
                debugPrint(error)
                return
            }
            
            //TODO : code for when ActivityController closes
        }
        present(activityController, animated: true, completion: nil)
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
    
    fileprivate func alert(message: String)  {
        let alertController = UIAlertController(title: "Ops!", message: message, preferredStyle: .actionSheet)
        alertController.oneAction()
        
        self.present(alertController, animated: true, completion: nil)
    }
}
