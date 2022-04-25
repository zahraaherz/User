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
    @IBOutlet var Indecator: UIActivityIndicatorView!
  
}
let ImageCache = NSCache<NSString, UIImage>()
extension UIImageView
{
    
    
    func downloadedFrom(_ urlS : String)
    {
        
        self.image = nil
        if let cacheImage = ImageCache.object(forKey: NSString(string: urlS)){
            
            self.image = cacheImage
        }
        guard let url = URL(string: urlS) else {return}
        
        URLSession.shared.dataTask(with: url ){ data, _, error in
            if let error = error {
                print(error)
            }
            if let data = data, let downloadImage = UIImage(data: data)
            {
                DispatchQueue.main.async {
                    self.image = downloadImage
                    ImageCache.setObject(downloadImage, forKey:  NSString(string: urlS) )
                }
            }
        }.resume()
    }
    /*func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit)
    {

        let strUniqueIdentifier_Initial = url.absoluteString
        self.accessibilityLabel = strUniqueIdentifier_Initial

        contentMode = mode
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }

            let strUniqueIdentifier_Current = self.accessibilityLabel
            if strUniqueIdentifier_Initial != strUniqueIdentifier_Current
            {
                return
            }

            DispatchQueue.main.async()
            {
                self.image = image
            }
        }
        dataTask.resume()
    }*/
}
