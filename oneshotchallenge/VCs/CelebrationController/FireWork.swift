//
//  FireWork.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-06-17.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class FireWork: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: - ball animation functions
    func animate() {
        coloredBalls.forEach { (ball) in
            ball.removeFromSuperview()
        }
        
        coloredBalls.removeAll()
        
        let positionDictionary : [[CGFloat: CGFloat]] = [[75: 75], [-75: -75],
                                                         [75: -75], [-75: 75],
                                                         [0: 100], [0: -100],
                                                         [100: 0], [-100: 0]]
        positionDictionary.forEach { (position) in
            guard let x = position.first?.key else { return }
            guard let y = position.first?.value else { return }
            
            addColoredBall(positionX: x, y: y)
        }
    }
    
    var coloredBalls = [UIView]()
    fileprivate func addColoredBall(positionX: CGFloat, y: CGFloat) {
        let newColor = color()
        
        let newBall = UIView()
        newBall.backgroundColor = newColor
        newBall.clipsToBounds = true
        newBall.layer.cornerRadius = 12.5
        newBall.layer.zPosition = -1
        
        addSubview(newBall)
        newBall.constraintLayout(top: nil, leading: nil, trailing: nil, bottom: nil,
                                 centerX: centerXAnchor, centerY: centerYAnchor,
                                 size: .init(width: 25, height: 25))
        
        coloredBalls.append(newBall)
        
        animateBallTo(ball: newBall, x: positionX, y: y)
    }
    
    fileprivate func color() -> UIColor
    {
        let colors = Colors.sharedInstance.celebrationColors
        let upperBound = UInt32(colors.count)
        let index = Int(arc4random_uniform(upperBound))
        let color = colors[index]
        
        return color
    }
    
    fileprivate func animateBallTo(ball: UIView, x: CGFloat, y: CGFloat) {
        ball.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            ball.transform = CGAffineTransform(scaleX: 1, y: 1)
            ball.transform = CGAffineTransform(translationX: x, y: y)
        }) { (_) in
            self.removeAnimation(ball: ball, positionX: x, positionY: y)
        }
    }
    
    fileprivate func removeAnimation(ball: UIView, positionX: CGFloat, positionY: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            ball.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            ball.transform = CGAffineTransform(translationX: positionX, y: positionY)
            ball.alpha = 0
        }) { (_) in
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
