//
//  CalendarHeader.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

protocol CalendarHeaderDelegate: class {
    func didChangeMonth(to month: Int)
}

class CalendarHeader: UICollectionReusableView {
    
    weak var delegate: CalendarHeaderDelegate?
    
    lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("minus", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.tintColor = Colors.sharedInstance.primaryTextColor
        button.addTarget(self, action: #selector(minusPress), for: .touchUpInside)
        return button
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("plus", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.tintColor = Colors.sharedInstance.primaryTextColor
        button.addTarget(self, action: #selector(plusPress), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.sharedInstance.primaryColor
        
        addSubview(minusButton)
        minusButton.constraintLayout(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, centerY: centerYAnchor,
                                     padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        
        addSubview(plusButton)
        plusButton.constraintLayout(top: nil, leading: nil, trailing: trailingAnchor, bottom: nil, centerY: centerYAnchor,
                                    padding: .init(top: 0, left: 0, bottom: 0, right: 8))
        
        let lineView = UIView()
        lineView.backgroundColor = Colors.sharedInstance.lightColor
        addSubview(lineView)
        lineView.constraintLayout(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor,
                                  padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 1))
    }
    
    @objc fileprivate func minusPress() {
        delegate?.didChangeMonth(to: -1)
    }
    
    @objc fileprivate func plusPress() {
        delegate?.didChangeMonth(to: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
