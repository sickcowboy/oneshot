//
//  ViewController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-04-24.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tabBar.barTintColor = Colors.sharedInstance.darkColor
        self.tabBar.tintColor = Colors.sharedInstance.primaryTextColor
        
        Auth.auth().addStateDidChangeListener { (_, user) in
            if user == nil {
                self.toLogin()
            } else {
                self.setUpControllers()
            }
        }
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
        
        navController?.navigationBar.barTintColor = Colors.sharedInstance.darkColor
        navController?.navigationBar.isTranslucent = false
        navController?.navigationBar.tintColor = Colors.sharedInstance.primaryTextColor
        
        return navController!
    }
    
    fileprivate func toLogin() {
        self.viewControllers = nil
        
        let loginController = UINavigationController(rootViewController: LoginVC())
        loginController.navigationBar.isHidden = true
        
        self.present(loginController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

