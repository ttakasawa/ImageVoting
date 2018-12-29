//
//  ImageLoadable.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol ImageLoadable {
    func downloadImage(stringUrl: String, completion: @escaping (_ image: UIImage) -> Void)
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage) -> Void)
}

extension ImageLoadable{
    func downloadImage(stringUrl: String, completion: @escaping (_ image: UIImage) -> Void) {
        
        if let url = URL(string: stringUrl){
            self.downloadImage(url: url) { (imageData) in
                completion(imageData)
            }
        }else{
            completion(UIImage())
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage) -> Void) {
        Alamofire.request(url).responseImage { (response) in
            if let image = response.result.value {
                completion(image)
            }else{
                completion(UIImage())
            }
        }
    }
}
