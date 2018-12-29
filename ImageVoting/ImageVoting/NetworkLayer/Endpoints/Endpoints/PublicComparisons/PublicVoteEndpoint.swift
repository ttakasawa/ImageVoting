//
//  PublicPostEndpoint.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/21/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

enum PublicVoteEndpoint: FirebaseEndpoint {
    
    //vote
    case getCounter(postId: String)
    case increment(postId: String, counter: Int)
    case removePostIdFromUserTable(userId: String, postId: String)
    case removeUserIdFromPostTable(postId: String, userId: String)
    
    case getUserVotableTableKeys(userId: String)
    
//    case postToGlobalLocation(post: ComparisonRecord)
//    case addPostKeyToUserTable(postId: String, userId: String)
//    case addUserKeyToPostTable(postId: String, userId: String)
    
    var path: String? {
        switch self {
        
        case .increment(let postId, _), .getCounter(let postId):
            return "PublicPost/\(postId)/counter"
            
        case .removePostIdFromUserTable(let userId, let postId):
            return "User-VotablePublicPostTable/\(userId)/\(postId)"
            
        case .removeUserIdFromPostTable(let postId, let userId):
            return "PublicPost-VotableUserTable/\(postId)/\(userId)"
            
        case .getUserVotableTableKeys(let userId):
            return "User-VotablePublicPostTable/\(userId)"
            
        }
    }
    
    var body: Any? {
        switch self {
        case .removePostIdFromUserTable( _, _), .removeUserIdFromPostTable( _, _), .getCounter( _), .getUserVotableTableKeys(_):
            return nil
        case .increment( _, let counter):
            return self.toData(object: counter)
        }
    }
    
    var type: EndpointsType? {
        switch self {
            case .getCounter( _):
            return EndpointsType.querySingleObject
            
        case .increment( _, _), .removePostIdFromUserTable( _, _), .removeUserIdFromPostTable( _, _):
            return EndpointsType.storeSingleObject
        case .getUserVotableTableKeys(_):
            return EndpointsType.queryListWithLimit
        }
    }
}
