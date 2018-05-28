//
//  RateControllerCollectionViewFunctions.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-04-27.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

extension RateController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if posts == nil {
            return 0
        }
        
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RateControllerCell

        let noPostsLeft = posts?.isEmpty ?? true
        
        if !noPostsLeft {
            cell.post = posts?[0]
            posts?.removeFirst()
        } else {
            cell.imageUrl = ""
        }
        
        cell.initialFetch = initialFetch
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return .zero}
        let size = (collectionView.frame.height - tabHeight) / 2
        
        return CGSize(width: size - 30, height: size - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(40, 0, 0, 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = (collectionView.cellForItem(at: indexPath) as! RateControllerCell).post
        
        let uid = post?.userId
        let challengeDate = post?.challengeDate
        let month = MonthKey.sharedInstance.monthKey(timeInterval: challengeDate)
        
        FBVote.sharedInstance.vote(uid: uid, id: key, month: month)
        
        collectionView.reloadData()
    }
}
