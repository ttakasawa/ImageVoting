//
//  PostEndpoint.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/29/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

enum PostEndpoint: FirebaseEndpoint {
    
    
    case getPosts(postId: String)
    
    var path: String? {
        switch self {
        case .getPosts(let postId):
            return "Post/\(postId)"
        }
    }
    
    var body: Any? {
        switch self {
        case .getPosts( _):
            return nil
        }
    }
    
    var type: EndpointsType? {
        switch self {
        case .getPosts( _):
            return EndpointsType.querySingleObject
        }
    }
}
