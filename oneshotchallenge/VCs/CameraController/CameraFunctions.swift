//
//  CameraFunctions.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit
import AVKit

extension CameraController {
    
    func setupCaptureSession() {
        if isOnBoarding {
            captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        } else {
            captureDevice = AVCaptureDevice.default(for: .video)
        }
        
        guard let captureDevice = captureDevice else { return }
        
        if captureSession == nil {
            captureSession = AVCaptureSession()
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession!.canAddInput(input) {
                captureSession!.addInput(input)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
        if captureSession!.canAddOutput(output) {
            captureSession!.addOutput(output)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer!.videoGravity = .resizeAspectFill
        captureSession!.startRunning()
        
        DispatchQueue.main.async {
            self.previewLayer!.frame = self.capturePreviewView.bounds
            guard let previewLayer = self.previewLayer else { return }
            self.capturePreviewView.layer.addSublayer(previewLayer)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        guard let takenPhoto = UIImage(data: imageData) else { return }
        guard let croppedPhoto = cropToPreviewLayer(originalImage: takenPhoto) else { return }
        
        DispatchQueue.main.async {
            self.goToEditPhotoController(image: croppedPhoto)
        }
    }
    
    func cropToPreviewLayer(originalImage: UIImage) -> UIImage? {
        guard let previewLayer = previewLayer else { return nil }
        let bounds = CGRect(x: 0, y: 0, width: previewLayer.frame.size.width, height: previewLayer.frame.size.height)
        let outputRect = previewLayer.metadataOutputRectConverted(fromLayerRect: bounds)
        var cgImage = originalImage.cgImage!
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropRect = CGRect(x: outputRect.origin.x * width, y: outputRect.origin.y * height, width: outputRect.size.width * width, height: outputRect.size.height * height)
        
        cgImage = cgImage.cropping(to: cropRect)!
        let croppedUIImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: originalImage.imageOrientation)
        
        return croppedUIImage
    }
    
    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        switch flashToggleButton.flashImage {
        case .on:
            settings.flashMode = .on
            break
        case .auto:
            settings.flashMode = .auto
            break
        case .off:
            settings.flashMode = .off
            break
        }
        
        DispatchQueue.global(qos: .default).async {
            self.output.capturePhoto(with: settings, delegate: self)
        }
    }
}
