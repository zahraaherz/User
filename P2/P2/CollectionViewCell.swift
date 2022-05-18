//
//  CollectionViewCell.swift
//  P2
//
//  Created by Zahraa Herz on 13/04/2022.
//

import UIKit
import Foundation
class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var Name: UILabel!
    @IBOutlet var Images: UIImageView!
}

let ImageCache = NSCache<NSString, UIImage>()

// MARK: -

extension UIImageView{
    
    func downloadedFrom(_ urlS : String) {
        
        self.image = nil
        if let cacheImage = ImageCache.object(forKey: NSString(string: urlS)){
            
            self.image = cacheImage
        }
        
        guard let url = URL(string: urlS) else {
            
            return
        }
        
        URLSession.shared.dataTask(with: url ){ data, _, error in
            
            if let error = error {
                
                print(error)
            }
            
            if let data = data, let downloadImage = UIImage(data: data){
                
                DispatchQueue.main.async {
                    
                    self.image = downloadImage
                    ImageCache.setObject(downloadImage, forKey:  NSString(string: urlS) )
                }
            }
        }.resume()
    }
}
