//
//  EditPhotoController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class EditPhototController: UIViewController, FilterSliderDelegate {
    let context = CIContext(options: nil)
    
    var photo: UIImage? {
        didSet{
            imageView.image = photo
        }
    }
    
    var unEditedPhoto: CIImage?
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var brightnessSlider: FilterSlider = {
        let fs = FilterSlider()
        fs.setUp(title: "brightness", minAmount: -0.5, setAmount: 0, maxAmount: 0.5)
        fs.delegate = self
        return fs
    }()
    
    lazy var contrastSlider: FilterSlider = {
        let fs = FilterSlider()
        fs.setUp(title: "contrast", minAmount: 0.5, setAmount: 1, maxAmount: 1.5)
        fs.delegate = self
        return fs
    }()
    
    lazy var saturationSlider: FilterSlider = {
        let fs = FilterSlider()
        fs.setUp(title: "saturation", minAmount: 0, setAmount: 1, maxAmount: 2)
        fs.delegate = self
        return fs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        view.addSubview(imageView)
        imageView.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil)
        imageView.squareByWidthAnchor()
        
        setUpSliderStackView()
        
        guard let photo = photo else { return }
        unEditedPhoto = CIImage(image: photo)
    }
    
    fileprivate func setUpSliderStackView() {
        let stackView = UIStackView(arrangedSubviews: [brightnessSlider, contrastSlider, saturationSlider])
        stackView.setUp(vertical: true, spacing: 8)

        
        view.addSubview(stackView)
        stackView.constraintLayout(top: imageView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    func sliderChanged() {
        filterImage()
    }
    
    fileprivate func filterImage() {
        if let currentFilter = CIFilter(name: "CIColorControls") {
            currentFilter.setValue(unEditedPhoto, forKey: "inputImage")
            currentFilter.setValue(brightnessSlider.slider.value, forKey: "inputBrightness")
            currentFilter.setValue(contrastSlider.slider.value, forKey: "inputContrast")
            currentFilter.setValue(saturationSlider.slider.value, forKey: "inputSaturation")
            
            guard let outputImage = currentFilter.outputImage else { return }
            guard let newCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
            guard let scale = imageView.image?.scale else { return }
            guard let orientation = imageView.image?.imageOrientation else { return }
            photo = UIImage(cgImage: newCGImage, scale: scale, orientation: orientation)
        }
    }
}
