//
//  FetchedImage.swift
//  remotepush
//
//  Created by Dennis Galvén on 2018-03-03.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

var imageCache = [String : UIImage]()

class UrlImageView: UIImageView {
    
    fileprivate var activityIndicator: UIActivityIndicatorView?
    
    private var lastUrl: String?
    
    func loadImage(urlString: String?) {
        loading()
        
        guard let urlString = urlString else {
            stopLoading()
            return
        }
        
        if urlString.isEmpty {
            self.image = #imageLiteral(resourceName: "NoImage")
            stopLoading()
            return
        }
        
        lastUrl = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            stopLoading()
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.stopLoading()
                debugPrint(error.localizedDescription)
                return
            }
            
            if url.absoluteString != self.lastUrl {
                self.stopLoading()
                return
            }
            
            guard let imageData = data else {
                self.stopLoading()
                return
            }
            
            let image = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = image
            
            DispatchQueue.main.async {
                self.stopLoading()
                self.image = image
            }
        }.resume()
    }
    
    fileprivate func loading() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator?.startAnimating()
        
        addSubview(activityIndicator!)
        activityIndicator?.constraintLayout(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
    }
    
    fileprivate func stopLoading() {
        activityIndicator?.removeFromSuperview()
        
        activityIndicator = nil
    }
}
