//
//  CelebrationView.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-06-17.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class CelebrationView: UIView {
    //MARK: - views
    let headLineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 44)
        label.textAlignment = .center
        label.textColor = Colors.sharedInstance.primaryTextColor
        label.text = "Congratulations"
        return label
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addLabel()
    }
    
    //MARK: - label animation functions
    fileprivate func addLabel() {
        addSubview(headLineLabel)
        headLineLabel.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil,
                                       centerX: centerXAnchor, centerY: centerYAnchor)
    }
    
    func animate() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.headLineLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.headLineLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.addFireWork()
            }, completion: nil)
        })
    }
    
    fileprivate func addFireWork() {
        let fireWork = FireWork()
        fireWork.layer.zPosition = -1
        addSubview(fireWork)
        fireWork.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil,
                                  centerX: centerXAnchor, centerY: centerYAnchor)
        
        fireWork.animate()
    }
    
    //MARK: - error handling
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
