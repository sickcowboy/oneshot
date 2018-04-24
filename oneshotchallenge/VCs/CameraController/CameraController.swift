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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        view.addSubview(capturePreviewView)
        capturePreviewView.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil)
        capturePreviewView.squareByWidthAnchor()
        
        DispatchQueue.global(qos: .utility).async {
            self.setupCaptureSession()
        }
    }
    
    fileprivate func setupCaptureSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        let captureSession = AVCaptureSession()
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
        let output = AVCapturePhotoOutput()
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        captureSession.startRunning()
        
        DispatchQueue.main.async {
            previewLayer.frame = self.capturePreviewView.frame
            self.capturePreviewView.layer.addSublayer(previewLayer)
        }
    }
}
