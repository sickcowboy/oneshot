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
    
    let photoImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        // TODO: ändra tillbaka till scaleAspectFit
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var image: UIImage? {
        didSet{
            photoImage.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(frameView)
        frameView.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        
        addSubview(photoImage)
        photoImage.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor,
                                    padding: .init(top: 50, left: 50, bottom: 50, right: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
