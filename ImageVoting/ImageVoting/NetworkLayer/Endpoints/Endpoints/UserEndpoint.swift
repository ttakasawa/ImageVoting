//
//  UserEndpoint.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/16/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

enum UserEndpoint: FirebaseEndpoint {
    
    case login
    case queryUser(userId: String)
    case updateUser(userId: String, user: UserData)
    
    case getAllResultKeys(userId: String)
    case getAllResults(postId: String)
    
    
    
    case getLatestResult(userId: String)
    
    
    
    var path: String? {
        switch self {
        case .login:
            return nil
        case .queryUser(let userId), .updateUser(let userId, _):
            return "User/\(userId)"
        case .getAllResultKeys(let userId):
            return "User/\(userId)/records"
        case .getLatestResult(let userId):
            return "Post-CreatorTable/\(userId)"
        case .getAllResults(let postId):
            return "Post/\(postId)"
        }
    }
    
    var body: Any? {
        switch self {
        case .login, .queryUser( _), .getAllResultKeys( _), .getLatestResult( _), .getAllResults( _):
            return nil
        case .updateUser(_, let user):
            return self.toData(object: user)
        }
    }
    
    var type: EndpointsType? {
        switch self {
        case .queryUser( _), .getAllResults( _):
            return EndpointsType.querySingleObject
        case .updateUser( _, _):
            return EndpointsType.storeSingleObject
        case .getAllResultKeys( _), .getLatestResult( _):
            return EndpointsType.queryList
        default:
            return nil
        }
    }
}
