//
//  UserController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class UserController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CalendarHeaderDelegate, CalendarCellDelegate {
    var user: LocalUser? {
        didSet {
            navigationController?.navigationBar.topItem?.title = user?.username
        }
    }
    
    var uid: String?
    
    var daysInMonth: Int? {
        didSet{
            collectionView?.reloadData()
        }
    }
    
    var challenges: [Challenge]? {
        didSet {
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
        
        fetchUser()
        
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func fetchUser() {
        let fbUser = FireBaseUser()
        fbUser.fetchUser(uid: uid) { (user) in
            DispatchQueue.main.async {
                self.user = user
            }
        }
    }
    
    fileprivate func fetchPosts() {
        let fbPosts = FireBasePosts()
        
        fbPosts.fetchUserFeed { (challenges) in
            DispatchQueue.main.async {
                self.challenges = challenges?.reversed()
            }
        }
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
    
    func didTapPicture(_ sender: Post) {
        let controller = DetailPostController()
        controller.post = sender
        
        navigationController?.pushViewController(controller, animated: true)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc fileprivate func toSettings() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(SettingsController(), animated: true)
    }
}
