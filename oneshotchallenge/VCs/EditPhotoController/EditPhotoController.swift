//
//  EditPhotoController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class EditPhototController: UIViewController, FilterSliderDelegate, UIScrollViewDelegate, CountDownTimerDelegate {
    let context = CIContext(options: nil)
    var isOnBoarding = false
    
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
    
    var post: Post?
    
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
        debugPrint("viewWillAppear")
        
        if !isOnBoarding {
            NotificationCenter.default.addObserver(self, selector: #selector(checkTimeAndStartCountDown),
                                                   name: .UIApplicationWillEnterForeground, object: nil)
           checkTimeAndStartCountDown()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("viewWillDissapear")
        NotificationCenter.default.removeObserver(self)
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
    
    @objc fileprivate func checkTimeAndStartCountDown() {
        countDownTimer.stopCountDown()
        
        if post == nil {
            startCountDown()
            return
        }
        
        let calendar = Calendar.current
        
        let startDate = Date(timeIntervalSince1970: post!.startDate)
        guard let endDate = calendar.date(byAdding: .hour, value: 1, to: startDate) else { return }
        let nowDate = Date()
        
        let components = calendar.dateComponents([.hour, .minute, .second], from: nowDate, to: endDate)
        
        guard let hour = components.hour else { return }
        guard let minute = components.minute else { return }
        guard let second = components.second else { return }
        
        if (hour <= 0 && minute <= 0 && second <= 0) {
            timesUp()
            return
        }
        
        startCountDown(hour: hour, minute: minute, second: second)
    }
    
    fileprivate func startCountDown(hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
        countDownTimer.delegate = self
        
        let hour = hour ?? 1
        let minute = minute ?? 0
        let second = second ?? 0
        
        countDownTimer.startCountDown(hours: hour, minutes: minute, seconds: second)
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
        
        let controller = PostController()
        controller.image = cropImage()
        controller.isOnBoarding = isOnBoarding

        navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func cropImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(scrollView.frame.size, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: -scrollView.contentOffset.x, y: -scrollView.contentOffset.y)
        scrollView.layer.render(in: context)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func timesUp() {
        navigationController?.popToRootViewController(animated: false)
    }
}
