//
//  FramedPhotoView.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class FramedPhotoView: UIView {
    let frameView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "frame"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let photoImageView: UrlImageView = {
        let iv = UrlImageView()
        iv.clipsToBounds = true
        // TODO: ändra tillbaka till scaleAspectFit
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    var image: UIImage? {
        didSet{
            photoImageView.image = image
        }
    }
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        let tR = UITapGestureRecognizer(target: self, action: #selector(enlargeImage(sender:)))
        tR.numberOfTapsRequired = 1
        return tR
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(frameView)
        frameView.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        
        photoImageView.addGestureRecognizer(tapRecognizer)
        
        let padding: CGFloat = 58
        addSubview(photoImageView)
        photoImageView.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor,
                                    padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    fileprivate var bigImage = false
    
    @objc func enlargeImage(sender: UITapGestureRecognizer) {
        if !bigImage {
            bigImage = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.photoImageView.transform = CGAffineTransform(scaleX: 1.58, y: 1.58)
            }, completion: nil)
        } else {
            bigImage = false
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.photoImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
