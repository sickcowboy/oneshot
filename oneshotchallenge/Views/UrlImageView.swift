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
    private var lastUrl: String?
    
    func loadImage(urlString: String?) {
        guard let urlString = urlString else {
            return
        }
        
        lastUrl = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            if url.absoluteString != self.lastUrl {
                return
            }
            
            guard let imageData = data else { return }
            let image = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = image
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
