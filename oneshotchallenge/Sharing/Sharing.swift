//
//  Sharing.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-05-29.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class Sharing {
    
     func shareToInstagram(image: UIImage) {
        debugPrint("sharing...\n")
        
        let activityController = UIActivityViewController(activityItems: [image, "#OneShotChallenge"], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceRect = view.bounds
        
        activityController.completionWithItemsHandler = { activity, success, items, error in
            print("activity: \(String(describing: activity)), success: \(success), items: \(String(describing: items)), error: \(String(describing: error))")
            
            if let error = error {
                debugPrint(error)
                return
            }
            self.navigationController?.popToRootViewController(animated: true)
            
        }
        present(activityController, animated: true, completion: nil)
    }
}
