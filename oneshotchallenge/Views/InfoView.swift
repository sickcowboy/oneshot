//
//  InfoView.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-31.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

protocol InfoViewDelegate: class {
    func okClick()
    func shareClick()
}

class InfoView: UIView {
    
    weak var delegate: InfoViewDelegate?

    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.sharedInstance.darkColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.sharedInstance.darkColor
        
        button.setTitle("OK", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setImage(#imageLiteral(resourceName: "Ok"), for: .normal)
        button.alignTextBelow(spacing: 0)
        
        button.sizeToFit()
        
        button.addTarget(self, action: #selector(okClick), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.sharedInstance.darkColor
        
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setImage(#imageLiteral(resourceName: "Share"), for: .normal)
        button.alignTextBelow(spacing: 0)
        
        button.sizeToFit()
        
        button.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        addSubview(contentView)
        contentView.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
    }
    
    func setText(text: String) {
        let attributedTitle = NSMutableAttributedString(string: "Nice work!",
                                                        attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 38),
                                                                     NSAttributedStringKey.foregroundColor: Colors.sharedInstance.darkColor])
        attributedTitle.append(NSAttributedString(string: "\n\(text)",
                                                  attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
                                                               NSAttributedStringKey.foregroundColor: Colors.sharedInstance.darkColor]))
        
        infoLabel.attributedText = attributedTitle
        
        setUpViews()
    }
    
    fileprivate func setUpViews() {
        contentView.addSubview(infoLabel)
        infoLabel.constraintLayout(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: nil,
                                   padding: .init(top: 8, left: 8, bottom: 0, right: 8))
        
        let stackView = UIStackView(arrangedSubviews: [shareButton, okButton])
        stackView.setUp(vertical: false, spacing: 4)
        
        contentView.addSubview(stackView)
        stackView.constraintLayout(top: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor,
                                   padding: .init(top: 0, left: 4, bottom: 0, right: 4),
                                   size: .init(width: 0, height: 80))
        
    }
    
    
    @objc fileprivate func okClick() {
        delegate?.okClick()
    }
    
    @objc fileprivate func shareClick() {
        delegate?.shareClick()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
