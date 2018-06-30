//
//  AllChallengesVC.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-06-30.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class AllChallengesVC : UITableViewController {
    var challenges : [Challenge]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Challenges"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        fetchChallenges()
    }
    
    fileprivate func fetchChallenges() {
        let fbChallenges = FireBaseChallenges()
        fbChallenges.fetchAllChallenges { (challenges) in
            DispatchQueue.main.async {
                self.challenges = challenges?.reversed()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = challenges?[indexPath.row].description
        cell.detailTextLabel?.text = challenges?[indexPath.row].dateString()
        return cell
    }
}
