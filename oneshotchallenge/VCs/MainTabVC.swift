//
//  ViewController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class MainTabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpControllers()
    }
    
    fileprivate func setUpControllers() {
        let challengeController = createController(image: nil, title: "Challenge", uiController: ChallengeController())
        let rateController = createController(image: nil, title: "Rate", collectionController: RateController(collectionViewLayout: UICollectionViewFlowLayout()))
        let topListController = createController(image: nil, title: "Toplist", collectionController: TopListController(collectionViewLayout: UICollectionViewFlowLayout()))
        let userController = createController(image: nil, title: "User", collectionController: UserController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        self.viewControllers = [challengeController, rateController, topListController, userController]
    }
    
    fileprivate func createController(image: UIImage?, title: String, collectionController: UICollectionViewController? = nil, uiController: UIViewController? = nil) -> UINavigationController {
        var navController : UINavigationController?
        
        if let collectionController = collectionController {
            navController = UINavigationController(rootViewController: collectionController)
        }
        
        if let uiController = uiController {
            navController = UINavigationController(rootViewController: uiController)
        }
        
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
        navController!.tabBarItem = tabBarItem
        
        return navController!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

