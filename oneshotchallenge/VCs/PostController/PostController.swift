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
    
    let frameView : FramedPhotoView = {
        let fpv = FramedPhotoView()
//        fpv.layer.shadowColor = UIColor.lightGray.cgColor
//        fpv.layer.shadowOpacity = 0.5
//        fpv.layer.shadowOffset = CGSize(width: -10, height: 10)
//        fpv.layer.shadowRadius = 1
        return fpv
    }()
    
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
        navigationController?.popToRootViewController(animated: true)
    }
}
