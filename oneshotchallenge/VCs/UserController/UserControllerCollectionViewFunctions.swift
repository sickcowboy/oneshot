//
//  UserControllerCollectionViewFunctions.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

extension UserController {
    
    //header functions
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if todayChallenge != nil {
//            let height = (collectionView.frame.width / 3) * 2
//            return CGSize(width: collectionView.frame.width, height: height)
//        }
//        
//        return .zero
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CalendarHeader
//        header.challenge = todayChallenge
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
//    }
    
    //cell functions
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challenges?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = collectionView.frame.width + 8
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalendarCell
        
        cell.challenge = challenges?[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    fileprivate func cellDate(day: Int?) -> Date? {
        guard let year = year else { return nil }
        guard let month = month else { return nil }
        guard let day = day else { return nil }
        
        let dateComponents = DateComponents(year: year, month: month, day: day)
        
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }
}
