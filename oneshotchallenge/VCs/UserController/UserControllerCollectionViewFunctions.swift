//
//  UserControllerCollectionViewFunctions.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

extension UserController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width/3) - 8
        return CGSize(width: size, height: size)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalendarCell
        
        if let date = cellDate(day: indexPath.row + 1) {
            cell.date = date
        }
        
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
