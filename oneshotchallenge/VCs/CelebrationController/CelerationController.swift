//
//  CelerationController.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-06-17.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class CelebrationController: UIViewController {
    //MARK: - properties
    var headLine: String? {
        didSet{
            
        }
    }
    
    var subLine: String? {
        didSet{
            
        }
    }
    
    //MARK: - views
    lazy var okButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(okClick), for: .touchUpInside)
        return button
    }()
    
    var celebrationView: CelebrationView?
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.sharedInstance.primaryColor
        StausBar.sharedInstance.changeColor(view: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addCelebrationView()
    }
    
    //MARK: - view setup
    fileprivate func addCelebrationView() {
        celebrationView = CelebrationView()
        guard let celebrationView = celebrationView else { return }
        
        view.addSubview(celebrationView)
        celebrationView.constraintLayout(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor,
                                         trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
        celebrationView.animate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        celebrationView?.animate()
    }
    
    //MARK: - actions
    @objc fileprivate func okClick() {
        
    }
}
