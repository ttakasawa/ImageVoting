//
//  ComparisonRecord.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
//uesr -> comparison records
//comparisons needs to be done ->

class ComparisonRecord: Codable {
    
    var comparisonId: String?
    var datePosted: Date
    var totalVoteNeeded: Int
    var voteType: VotingSelection
    
    var image1Url: String
    var image2Url: String
    
    var image1VoteCount: Int
    var image2VoteCount: Int
    
    var img1: UIImage?
    var img2: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case comparisonId, datePosted, totalVoteNeeded, voteType, image1Url, image2Url, image1VoteCount, image2VoteCount
    }
    
    var totalVotes: Int {
        return self.image1VoteCount + self.image2VoteCount
    }
    
    var image1Percentage: Int? {
        return 100 * self.image1VoteCount / self.totalVotes
    }
    var image2Percentage : Int? {
        return 100 * self.image2VoteCount / self.totalVotes
    }
    
    init (image1Url: String, image2Url: String, maxVotes: Int, voteType: VotingSelection){
        self.image1Url = image1Url
        self.image2Url = image2Url
        self.image1VoteCount = 0
        self.image2VoteCount = 0
        //self.image2VoteCount = 0
        self.datePosted = Date()
        self.totalVoteNeeded = maxVotes
        self.voteType = voteType
    }
    
}


enum ImageSelection {
    case image1
    case image2
}

enum VotingSelection: String, Codable {
    case privateSelection
    case publicSelection
}
