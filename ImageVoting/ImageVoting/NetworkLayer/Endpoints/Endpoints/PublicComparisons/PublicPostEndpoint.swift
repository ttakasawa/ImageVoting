//
//  PublicPostEndpoint.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/24/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

enum PublicPostEndpoint: FirebaseEndpoint {
    
    case postComparison(userId: String, comparison: ComparisonRecord)
    
    
    var path: String? {
        switch self{
        case .postComparison(_, _):
            return "publicPost"
        }
    }
    
    var body: Any? {
        switch self{
        case .postComparison(let userId, let comparison):
            return [
                "userId" : userId,
                "timestamp" : comparison.timestamp.timeIntervalSince1970,
                "image1Url" : comparison.image1Url,
                "image2Url" : comparison.image2Url,
                "totalVotesNeeded" : comparison.totalVotesNeeded,
                "voteType" : comparison.voteType
            ]
        }
    }
    
    var type: EndpointsType? {
        switch self{
        case .postComparison( _):
            return EndpointsType.httpRequest
        }
    }
    
    
}
