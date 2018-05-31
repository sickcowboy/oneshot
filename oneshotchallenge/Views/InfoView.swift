//
//  InfoView.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-31.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class InfoView: UIView {

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
        button.tintColor = Colors.sharedInstance.primaryTextColor
        button.backgroundColor = Colors.sharedInstance.primaryColor
        
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.sharedInstance.primaryTextColor.cgColor
        
        button.setTitle("OK", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        button.addTarget(self, action: #selector(okClick), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.sharedInstance.primaryTextColor
        button.backgroundColor = Colors.sharedInstance.primaryColor
        
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.sharedInstance.primaryTextColor.cgColor
        
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        button.addTarget(self, action: #selector(okClick), for: .touchUpInside)
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
        stackView.setUp(vertical: false, spacing: 0)
        
        contentView.addSubview(stackView)
        stackView.constraintLayout(top: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor,
                                   size: .init(width: 0, height: 50))
        
    }
    
    
    @objc fileprivate func okClick() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
