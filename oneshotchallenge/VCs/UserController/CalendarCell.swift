//
//  CalendarCell.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    var date: Date? {
        didSet{
            urlImageView.image = nil
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            guard let date = date else { return }
            dateLabel.text = dateFormatter.string(from: date)
            
            let today = Date()
            if today.timeIntervalSince1970 < date.timeIntervalSince1970 {
                dateLabel.textColor = Colors.sharedInstance.secondaryColor
            } else {
                dateLabel.textColor = Colors.sharedInstance.primaryTextColor
            }
            
            let cetTime = CETTime()
            
            challengeDate = cetTime.calendarChallengeDate(date: date)
        }
    }
    
    fileprivate var challengeDate: Date? {
        didSet{
            guard let challengeDate = challengeDate else { return }
            let fbPosts = FireBasePosts()
            
            fbPosts.fetchCalendarPost(date: challengeDate, completion: { (post) in
                DispatchQueue.main.async {
                    self.post = post
                }
            })
        }
    }
    
    fileprivate var post: Post? {
        didSet {
            urlImageView.loadImage(urlString: post?.imageUrl)
        }
    }
    
    fileprivate let urlImageView = UrlImageView()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dateLabel)
        dateLabel.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil,
                                   padding: .init(top: 4, left: 4, bottom: 0, right: 0))
        
        addSubview(urlImageView)
        urlImageView.contentMode = .scaleAspectFit
        urlImageView.clipsToBounds = true
        urlImageView.constraintLayout(top: dateLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor,
                                      padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
