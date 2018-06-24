//
//  RateControllerCell.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-04-27.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class RateControllerCell: UICollectionViewCell {
    
    var imageUrl: String? {
        didSet{
            imageView.reset()
            animateDown()
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
            self.imageView.image = self.image
            self.animateBack()
        }
    }
    
    let imageView : FramedPhotoView = {
        let iv = FramedPhotoView()
        return iv
    }()
    
    let starImageView : UIImageView = {
        let image = #imageLiteral(resourceName: "Star")
        let iv = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = Colors.sharedInstance.primaryTextColor
        return iv
    }()
    
    var initialFetch = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        
        
        if initialFetch {
            imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            imageView.alpha = 0
        }
    }
    
    func animateDown() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.imageView.alpha = 0
        }, completion: nil)
    }
    
    fileprivate func animateBack() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.imageView.alpha = 1
            self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
