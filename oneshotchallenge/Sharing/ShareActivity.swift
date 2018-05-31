//
//  ShareActivity.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-05-31.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class ShareActivity {
    
    func share(image: UIImage?, viewController: UIViewController, view: UIView) {
        guard let image = image else { return }
        let imageText = "#OneShotChallenge"
        
        let activityController = UIActivityViewController(activityItems: [image, imageText], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceRect = view.bounds
        
        activityController.excludedActivityTypes = [
            .postToWeibo,
            .print,
            .assignToContact,
            .addToReadingList,
            .postToVimeo,
            .postToTencentWeibo,
            .airDrop,
            .saveToCameraRoll,
            .copyToPasteboard
        ]
        
        activityController.completionWithItemsHandler = { activity, success, items, error in
            print("activity: \(String(describing: activity)), success: \(success), items: \(String(describing: items)), error: \(String(describing: error))")
            
            if let error = error {
                debugPrint(error)
                return
            }
            
            //TODO : code for when ActivityController closes
        }
        
        viewController.present(activityController, animated: true, completion: nil)
    }
    
    func shareToInstagram(image: UIImage?, viewController: UIViewController) {
        guard let image = image else { return }
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let checkValidation = FileManager.default
        let getImagePath = paths.appending("image.igo")
        try?  checkValidation.removeItem(atPath: getImagePath)
        let imageData =  UIImageJPEGRepresentation(image, 1.0)
        try? imageData?.write(to: URL.init(fileURLWithPath: getImagePath), options: .atomicWrite)
        var documentController : UIDocumentInteractionController!
        documentController = UIDocumentInteractionController.init(url: URL.init(fileURLWithPath: getImagePath))
        documentController.uti = "com.instagram.exclusivegram"
        
        documentController.presentOptionsMenu(from: viewController.view.frame, in: viewController.view, animated: true)
    }
}

