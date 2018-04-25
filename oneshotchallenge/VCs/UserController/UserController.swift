//
//  UserController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class UserController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CalendarHeaderDelegate {
    var daysInMonth: Int? {
        didSet{
            collectionView?.reloadData()
        }
    }
    
    var currentDate: Date?
    var month: Int?
    var year: Int?
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = Colors.sharedInstance.primaryColor
        collectionView?.register(CalendarHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(CalendarCell.self, forCellWithReuseIdentifier: cellId)
        (collectionViewLayout as! UICollectionViewFlowLayout).sectionHeadersPinToVisibleBounds = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Settings"), style: .plain, target: self, action: #selector(toSettings))
        
        setCalendar()
    }
    
    fileprivate func setCalendar(monthToSet: Int = 0) {
        if currentDate == nil {
            currentDate = Date()
        }
        
        let calendar = Calendar.current
        currentDate = calendar.date(byAdding: .month, value: monthToSet, to: currentDate!)
        let dayCount = calendar.range(of: .day, in: .month, for: currentDate!)?.count
        
        let components = calendar.dateComponents([.month, .year], from: currentDate!)
        month = components.month
        year = components.year
        
        daysInMonth = dayCount
    }
    
    func didChangeMonth(to month: Int) {
        setCalendar(monthToSet: month)
    }
    
    @objc fileprivate func toSettings() {
        
    }
}
