//
//  RateFrameImageView.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-06-16.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

protocol RateFrameImageViewDelegate: class {
    func didVote(sender: RateFrameImageView)
    func doneWithDownLoad(sender: RateFrameImageView)
    func doneWithAnimationAndNothingToShow(sender: RateFrameImageView)
}

class RateFrameImageView: UIView {
    var isOnBoarding = false
    
    weak var delegate : RateFrameImageViewDelegate?
    
    var imageUrl: String? {
        didSet{
            fetchImage()
        }
    }
    
    var post: Post? {
        didSet{
            self.imageUrl = post?.imageUrl
        }
    }
    
    var image: UIImage? {
        didSet{
            self.doneFetching()
        }
    }
    
    let imageView : FramedPhotoView = {
        let iv = FramedPhotoView()
        return iv
    }()
    
    let starImageView : UIImageView = {
        let image = #imageLiteral(resourceName: "Star")
        let iv = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        iv.tintColor = Colors.sharedInstance.primaryTextColor
        iv.alpha = 0
        return iv
    }()
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        let tR = UITapGestureRecognizer(target: self, action: #selector(voteTap(sender:)))
        tR.numberOfTapsRequired = 1
        return tR
    }()
    
    var positionIndex: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        
        addGestureRecognizer(tapRecognizer)
        
        self.imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.imageView.alpha = 0
        
        addSubview(starImageView)
        starImageView.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil,
                                       centerX: centerXAnchor, centerY: centerYAnchor,
                                       size: .init(width: 10, height: 10))
    }
    
    //MARK: - actions
    let fbVote = FBVote()
    @objc func voteTap(sender: UITapGestureRecognizer) {
        if !isOnBoarding {
            if post == nil { return }
        }
        
        isUserInteractionEnabled = false
        
        animateVote()
        delegate?.didVote(sender: self)
    }
    
    //MARK: - animations
    var animationDownDone = false
    func animateDown() {
        animationDownDone = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.imageView.alpha = 0
        }, completion: { _ in
            self.animationDownDone = true
            if self.post == nil {
                self.animationDone()
            }
        })
    }
    
    func animateBack() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.imageView.alpha = 1
            self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in
            self.isUserInteractionEnabled = true
        })
    }
    
    fileprivate func animateVote() {
        starImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.starImageView.transform = CGAffineTransform(scaleX: 10, y: 10)
            self.starImageView.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.starImageView.alpha = 0
            }, completion: { (_) in
                self.animateDown()
            })
        })
    }
    
    //MARK: - fetching function and handling
    fileprivate func fetchImage() {
        guard let urlString = imageUrl else { return }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let imageData = data else { return }
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
    var initialFetch = true
    fileprivate func doneFetching() {
        if initialFetch {
            self.imageView.image = self.image
            delegate?.doneWithDownLoad(sender: self)
            initialFetch = false
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            if self.animationDownDone {
                self.animationDownDone = false
                self.imageView.image = self.image
                self.delegate?.doneWithDownLoad(sender: self)
                timer.invalidate()
            }
        }
    }
    
    fileprivate func animationDone() {
        if isOnBoarding {
            if self.image == nil {
                delegate?.doneWithAnimationAndNothingToShow(sender: self)
            }
            return
        }
        delegate?.doneWithAnimationAndNothingToShow(sender: self)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
