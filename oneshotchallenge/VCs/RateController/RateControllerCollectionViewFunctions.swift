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
            setUpRefresh()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return .zero}
        let size = (collectionView.frame.height - tabHeight) / 2
        
        return CGSize(width: size - 4, height: size - 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        guard let tabHeight = tabBarController?.tabBar.frame.height else { return .zero}
//        let top = (collectionView.frame.height - tabHeight) / 2
//        return UIEdgeInsetsMake(10, 0, 0, 0)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = (collectionView.cellForItem(at: indexPath) as! RateControllerCell).post
        
        let uid = post?.userId
        let challengeDate = post?.challengeDate
        let month = MonthKey.sharedInstance.monthKey(timeInterval: challengeDate)
        
        FBVote.sharedInstance.vote(uid: uid, id: challenge?.key, month: month)
        
        voteCount! += 1
        
        if voteCount! < 10 {
            collectionView.reloadData()
        }
    }
    
    //Header functions
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! RateControllerHeader
//        
//        return header
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        
//        let width = view.frame.width
//        
//        return CGSize(width: width, height: 60)
//    }
}
