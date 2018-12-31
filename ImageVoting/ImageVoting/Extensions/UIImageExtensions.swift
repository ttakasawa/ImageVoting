//
//  UIImageExtensions.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/31/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

extension UIImage{
    
    func resizeForVote() -> UIImage {
        return self.resizeImageWith(newSize: CGSize(width: 180, height: 180))
    }
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
