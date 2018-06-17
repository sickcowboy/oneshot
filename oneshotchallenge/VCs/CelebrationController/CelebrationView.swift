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
    let coloredBall: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12.5
        return view
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        animate()
    }
    
    func animate() {
        coloredBalls.forEach { (ball) in
            ball.removeFromSuperview()
        }
        
        coloredBalls.removeAll()
        
        let positions: [CGFloat] = [75, -75]
        
        positions.forEach { (position) in
            addColoredBall(position: position)
        }
    }
    
    var coloredBalls = [UIView]()
    fileprivate func addColoredBall(position: CGFloat) {
        let colors = Colors.sharedInstance.celebrationColors
        let upperBound = UInt32(colors.count)
        let index = Int(arc4random_uniform(upperBound))
        let color = colors[index]
        
        let newBall = UIView()
        newBall.backgroundColor = color
        newBall.clipsToBounds = true
        newBall.layer.cornerRadius = 12.5
        
        addSubview(newBall)
        newBall.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil,
                                     centerX: centerXAnchor, centerY: centerYAnchor,
                                     size: .init(width: 25, height: 25))
        
        coloredBalls.append(newBall)
        
        animateBallTo(ball: newBall, x: position, y: position)
    }
    
    fileprivate func animateBallTo(ball: UIView, x: CGFloat, y: CGFloat) {
        self.coloredBall.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            ball.transform = CGAffineTransform(scaleX: 1, y: 1)
            ball.transform = CGAffineTransform(translationX: x, y: y)
            self.layoutIfNeeded()
        }) { (_) in
            self.removeAnimation(ball: ball)
        }
    }
    
    fileprivate func removeAnimation(ball: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            ball.alpha = 0
            self.layoutIfNeeded()
        }) { (_) in
        }
    }
    
    //MARK: - error handling
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
