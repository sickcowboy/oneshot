//
//  UrlImageFetcher.swift
//  oneshotchallenge
//
//  Created by Dennis Galvén on 2018-07-04.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class UrlImageFetcher {
    var lastUrl = ""
    
    func loadImage(urlString: String?, completion: @escaping(UIImage?) -> ()) {
        guard let urlString = urlString else {
            return
        }
        
        if urlString.isEmpty {
            return
        }
        
        lastUrl = urlString
        
        if let cachedImage = imageCache[urlString] {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    debugPrint(error.localizedDescription)
                    completion(nil)
                    return
                }
                
                if url.absoluteString != self.lastUrl {
                    completion(nil)
                    return
                }
                
                guard let imageData = data else {
                    completion(nil)
                    return
                }
                
                let image = UIImage(data: imageData)
                
                imageCache[url.absoluteString] = image
                
                completion(image)
            }
        }.resume()
    }
}
