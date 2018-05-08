//
//  DetailPostController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class DetailPostController: UIViewController {
    var post: Post? {
        didSet{
            frameView.photoImageView.loadImage(urlString: post?.imageUrl)
            setDateLabelText()
        }
    }
    
    fileprivate let frameView = FramedPhotoView()
    
    fileprivate let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Colors.sharedInstance.darkColor
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.sharedInstance.lightColor
        
        view.addSubview(frameView)
        frameView.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil, centerX: view.safeAreaLayoutGuide.centerXAnchor, centerY: view.safeAreaLayoutGuide.centerYAnchor,
                                   size: .init(width: view.frame.width - 50, height: view.frame.width - 50))
        
        view.addSubview(dateLabel)
        dateLabel.constraintLayout(top: frameView.bottomAnchor, leading: frameView.leadingAnchor, trailing: frameView.trailingAnchor, bottom: nil, padding: .init(top: 4, left: 4, bottom: 0, right: 4))
    }
    
    fileprivate func setDateLabelText() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        guard let timeInterval = post?.date else { return }
        let date = Date(timeIntervalSince1970: timeInterval)
        
        dateLabel.text = dateFormatter.string(from: date)
    }
}
