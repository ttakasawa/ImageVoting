//
//  StorageEndpoint.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/22/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

enum StorageEndpoint: FirebaseEndpoint {
    
    
    case PublicImagePost(image: UIImage, user: UserData, postClientId: String)
    case PrivateImagePost(image: UIImage, user: UserData, postClientId: String)
    
    var path: String? {
        switch self {
        case .PublicImagePost( _, let user, let postClientId):
            return "PublicImagePost/\(user.userId)/\(postClientId)"
        case .PrivateImagePost( _, let user, let postClientId):
            return "PrivateImagePost/\(user.userId)/\(postClientId)"
        }
    }
    
    var body: Any? {
        switch  self {
        case .PublicImagePost(let image, _, _), .PrivateImagePost(let image, _, _):
            guard let pngImage = image.pngData() else { return nil }
            return pngImage
        }
    }
    
    var type: EndpointsType? {
        return nil
    }
    
    
}
