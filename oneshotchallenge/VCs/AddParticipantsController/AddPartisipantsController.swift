//
//  AddPartisipantsController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-07-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class AddPartisipantsController: UITableViewController {
    fileprivate let fbUser = FireBaseUser()
    fileprivate let fbRating = FireBaseRating()
    fileprivate let fbAdmin = FBAdmin()
    fileprivate let cellId = "cellId"
    
    var posts: [Post]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add partisipants"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        fbAdmin.fetchAllPosts { (posts) in
            DispatchQueue.main.async {
                self.posts = posts
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        guard let post = posts?[indexPath.item] else { return cell }
        fbUser.fetchUser(uid: post.userId) { (user) in
            DispatchQueue.main.async {
                cell.textLabel?.text = user?.username
            }
        }
        
        fbAdmin.checkPartisipant { (userIds) in
            if let userIds = userIds {
                if userIds.contains(post.userId) {
                    DispatchQueue.main.async {
                        cell.detailTextLabel?.text = "Added"
                    }
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts?[indexPath.row]
        if tableView.cellForRow(at: indexPath)?.detailTextLabel?.text != nil { return }
        
        fbRating.addPartisipant(uid: post?.userId)
        tableView.reloadData()
    }
}
