//
//  TopListCollectionViewFunctions.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-14.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

extension TopListController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId,
                                                                     for: indexPath) as! TopListControllerHeader
        let title = segmentedView.titleForSegment(at: segmentedView.selectedSegmentIndex)
        header.setTitle(title: title ?? "")
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 22)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedView.selectedSegmentIndex {
        case 0:
            return todayScore?.count ?? 0
        case 1:
            return monthScore?.count ?? 0
        case 2:
            return allTimeScore?.count ?? 0
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TopListControllerCell
        
        switch segmentedView.selectedSegmentIndex {
        case 0:
            cell.topListScore = todayScore?[indexPath.item]
            break
        case 1:
            cell.topListScore = monthScore?[indexPath.item]
            break
        case 2:
            cell.topListScore = allTimeScore?[indexPath.item]
            break
        default:
            break
        }
        
        cell.placement = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 45)
    }
}
