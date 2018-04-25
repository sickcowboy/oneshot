//
//  UserController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class UserController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var daysInMonth: Int? {
        didSet{
            collectionView?.reloadData()
        }
    }
    
    var month: Int?
    var year: Int?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = Colors.sharedInstance.primaryColor
        collectionView?.register(CalendarCell.self, forCellWithReuseIdentifier: cellId)
        
        navigationController?.navigationBar.barTintColor = Colors.sharedInstance.darkColor
        navigationController?.navigationBar.tintColor = Colors.sharedInstance.primaryTextColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Settings"), style: .plain, target: self, action: #selector(toSettings))
        
        numberOfDaysInMonth()
    }
    
    fileprivate func numberOfDaysInMonth() {
        let date = Date()
        let calendar = Calendar.current
        let dayCount = calendar.range(of: .day, in: .month, for: date)?.count
        
        let components = calendar.dateComponents([.month, .year], from: date)
        month = components.month
        year = components.year
        
        daysInMonth = dayCount
    }
    
    @objc fileprivate func toSettings() {
        
    }
}
