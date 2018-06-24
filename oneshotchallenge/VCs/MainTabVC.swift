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
    
    private let fbUser = FireBaseUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tabBar.barTintColor = Colors.sharedInstance.darkColor
        self.tabBar.tintColor = Colors.sharedInstance.primaryTextColor
        
        Auth.auth().addStateDidChangeListener { (_, user) in
            
            if user == nil {
                self.toLogin()
            } else {
                self.fbUser.checkIfOnBoarding(completion: { (profileExists) in
                    guard let profileExists = profileExists else { return }

                    DispatchQueue.main.async {
                        if profileExists {
                            self.setUpControllers()
                        } else {
                            self.toOnBoarding()
                        }
                    }
                })
//                self.setUpControllers()
            }
        }
    }

    fileprivate func setUpControllers() {
        // TODO : Replace placeholder icons
        let challengeController = createController(image: #imageLiteral(resourceName: "Challenge"), title: "Challenge", uiController: ChallengeController())
//        let rateController = createController(image: #imageLiteral(resourceName: "Rate"), title: "Vote", collectionController: RateController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let rateControllerDeux = createController(image: #imageLiteral(resourceName: "Rate"), title: "Vote", uiController: RateControllerDeux())
        
//        let topListController = createController(image: #imageLiteral(resourceName: "Toplist"), title: "Toplist", collectionController: TopListController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let userController = createController(image: #imageLiteral(resourceName: "User"), title: "User", collectionController: UserController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // TODO : Insert toop list controller back into app
        self.viewControllers = [challengeController, rateControllerDeux, userController]
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
        navController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.sharedInstance.primaryTextColor]
        
        return navController!
    }
    
    fileprivate func toLogin() {
        self.viewControllers = nil
        
        let loginController = UINavigationController(rootViewController: LoginVC())
        loginController.navigationBar.isHidden = true
        
        self.present(loginController, animated: true, completion: nil)
    }
    
    fileprivate func toOnBoarding() {
        let onBoardingController = OBWelcomeController()
        self.present(onBoardingController, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

