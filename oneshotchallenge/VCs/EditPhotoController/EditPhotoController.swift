//
//  EditPhotoController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class EditPhototController: UIViewController, FilterSliderDelegate, UIScrollViewDelegate {
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
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.minimumZoomScale = 1
        sv.maximumZoomScale = 2
        sv.setZoomScale(1, animated: false)
        return sv
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
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.tintColor = Colors.sharedInstance.primaryTextColor
        button.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        return button
    }()
    
    var countDownTimer = CountDownTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.sharedInstance.primaryColor
        
        view.addSubview(scrollView)
        scrollView.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil,
                                   padding: .init(top: 16, left: 32, bottom: 0, right: 32))
        scrollView.squareByWidthAnchor()
        
        let size = view.frame.width - 64
        scrollView.addSubview(imageView)
        imageView.constraintLayout(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, trailing: nil, bottom: scrollView.bottomAnchor, size: .init(width: size, height: size))
    
        setUpUI()
        
        guard let photo = photo else { return }
        unEditedPhoto = CIImage(image: photo)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        saveButton.isUserInteractionEnabled = true
//        brightnessSlider.slider.isUserInteractionEnabled = true
//        contrastSlider.slider.isUserInteractionEnabled = true
//        saturationSlider.slider.isUserInteractionEnabled = true
    }
    
    var stackView = UIStackView()
    
    fileprivate func setUpUI() {
        view.addSubview(countDownTimer)
        countDownTimer.constraintLayout(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                        size: .init(width: 0, height: 80))
        
        view.addSubview(saveButton)
        saveButton.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: countDownTimer.topAnchor, centerX: view.centerXAnchor,
                                    padding: .init(top: 0, left: 0, bottom: 16, right: 0))
        
        stackView = UIStackView(arrangedSubviews: [brightnessSlider, contrastSlider, saturationSlider])
        stackView.setUp(vertical: true, spacing: 8)

        
        view.addSubview(stackView)
        stackView.constraintLayout(top: scrollView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: saveButton.topAnchor,
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
    
    @objc fileprivate func saveClick() {
        countDownTimer.stopCountDown()
        
//        saveButton.isUserInteractionEnabled = false
//        brightnessSlider.slider.isUserInteractionEnabled = false
//        contrastSlider.slider.isUserInteractionEnabled = false
//        saturationSlider.slider.isUserInteractionEnabled = false
        
        let controller = PostController()
        controller.image = cropImage()

        navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func cropImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(scrollView.frame.size, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: -scrollView.contentOffset.x, y: -scrollView.contentOffset.y)
        scrollView.layer.render(in: context)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage;
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
