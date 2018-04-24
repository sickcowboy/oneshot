//
//  FilterSlider.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

protocol FilterSliderDelegate: class {
    func sliderChanged()
}

class FilterSlider: UIView {
    
    weak var delegate: FilterSliderDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Colors.sharedInstance.primaryTextColor
        return label
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.tintColor = Colors.sharedInstance.secondaryColor
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil)
        
        addSubview(slider)
        slider.constraintLayout(top: titleLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil,
                                padding: .init(top: 4, left: 0, bottom: 0, right: 0))
    }
    
    func setUp(title: String, minAmount: Float, setAmount: Float, maxAmount: Float) {
        titleLabel.text = title
        slider.minimumValue = minAmount
        slider.value = setAmount
        slider.maximumValue = maxAmount
    }
    
    @objc fileprivate func sliderChanged() {
        delegate?.sliderChanged()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
