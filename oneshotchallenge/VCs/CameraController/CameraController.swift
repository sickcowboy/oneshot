//
//  CameraController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit
import AVKit

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    let capturePreviewView = UIView()
    let output = AVCapturePhotoOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    let challengeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    lazy var captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        
        button.layer.borderColor = Colors.sharedInstance.secondaryColor.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 35
        
        button.tintColor = Colors.sharedInstance.darkColor
        
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        challengeLabel.text = "BIG RED"
        view.addSubview(challengeLabel)
        challengeLabel.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil,
                                        padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        
        view.addSubview(capturePreviewView)
        capturePreviewView.constraintLayout(top: challengeLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil,
                                            padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        capturePreviewView.squareByWidthAnchor()
        
        view.addSubview(captureButton)
        captureButton.constraintLayout(top: capturePreviewView.bottomAnchor, leading: nil, trailing: nil, bottom: nil, centerX: view.centerXAnchor,
                                       padding: .init(top: 26, left: 0, bottom: 0, right: 0), size: .init(width: 70, height: 70))
        
        DispatchQueue.global(qos: .utility).async {
            self.setupCaptureSession()
        }
    }
    
    func goToEditPhotoController(image: UIImage) {
        let controller = EditPhototController()
        controller.photo = image
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
