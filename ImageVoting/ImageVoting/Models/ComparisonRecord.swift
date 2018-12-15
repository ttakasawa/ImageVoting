//
//  ComparisonRecord.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
//uesr -> comparison records
//comparisons needs to be done ->

class ComparisonRecord {
    
    var comparisonId: String?
    var datePosted: Date
    var counter: Int
    var totalVoteNeeded: Int
    var voteType: VotingSelection
    
    var image1Url: String
    var image2Url: String
    
    var image1Vote: Int
    var image2Vote: Int
    
    var totalVotes: Int {
        return self.image1Vote + self.image2Vote
    }
    
    var image1Percentage: Int? {
        return 100 * self.image1Vote / self.totalVotes
    }
    var image2Percentage : Int? {
        return 100 * self.image2Vote / self.totalVotes
    }
    
    init (image1Url: String, image2Url: String, maxVotes: Int, voteType: VotingSelection){
        self.image1Url = image1Url
        self.image2Url = image2Url
        self.image1Vote = 0
        self.image2Vote = 0
        self.datePosted = Date()
        self.totalVoteNeeded = maxVotes
        self.counter = 0
        self.voteType = voteType
    }
    
    func updateVote(selected: ImageSelection) {
        if selected == .image1 {
            self.image1Vote += 1
        }else{
            self.image2Vote += 1
        }
    }
}


enum ImageSelection {
    case image1
    case image2
}

enum VotingSelection {
    case privateSelection
    case publicSelection
}
