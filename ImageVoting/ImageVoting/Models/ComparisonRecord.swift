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
    var timestamp: Date
    var totalVotesNeeded: Int
    var voteType: VotingSelection
    
    var image1Url: String
    var image2Url: String
    
    var image1VoteCount: Int
    var image2VoteCount: Int
    
    var img1: UIImage?
    var img2: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case comparisonId, timestamp, totalVotesNeeded, voteType, image1Url, image2Url, image1VoteCount, image2VoteCount
    }
    
    convenience required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let timestampString: String = try container.decode(String.self, forKey: .timestamp) // extracting the data
        let totalVoteNeededString: String = try container.decode(String.self, forKey: .totalVotesNeeded) // extracting the data
        let image1VoteCountInt: Int = try container.decode(Int.self, forKey: .image1VoteCount) // extracting the data
        let image2VoteCountInt: Int = try container.decode(Int.self, forKey: .image2VoteCount) // extracting the data
        
        
        let totalVoteNeededInt: Int = Int(totalVoteNeededString) ?? 10
        let timestampDate: Date = Date(timeIntervalSince1970: Double(timestampString) ?? Date().timeIntervalSince1970)
        
        let voteType: VotingSelection = try VotingSelection(rawValue: container.decode(String.self, forKey: .voteType)) ?? .publicSelection // extracting the data
        let image1Url: String = try container.decode(String.self, forKey: .image1Url) // extracting the data
        let image2Url: String = try container.decode(String.self, forKey: .image2Url) // extracting the data
        
        var comparisonId: String?
        
        do{
            comparisonId = try container.decode(String.self, forKey: .comparisonId)
        }catch{
            comparisonId = nil
        }
        
        
        self.init(comparisonId: comparisonId, timestamp: timestampDate, totalVoteNeeded: totalVoteNeededInt, voteType: voteType, image1Url: image1Url, image2Url: image2Url, image1VoteCount: image1VoteCountInt, image2VoteCount: image2VoteCountInt)
    }
    
    var totalVotes: Int {
        return self.image1VoteCount + self.image2VoteCount
    }
    
    var image1Percentage: Int? {
        if totalVotes == 0 {
            return nil
        }else{
            return 100 * self.image1VoteCount / self.totalVotesNeeded
        }
        
    }
    var image2Percentage : Int? {
        if totalVotes == 0 {
            return nil
        }else{
            return 100 * self.image2VoteCount / self.totalVotesNeeded
        }
    }
    
    init (image1Url: String, image2Url: String, maxVotes: Int, voteType: VotingSelection){
        self.image1Url = image1Url
        self.image2Url = image2Url
        self.image1VoteCount = 0
        self.image2VoteCount = 0
        //self.image2VoteCount = 0
        self.timestamp = Date()
        self.totalVotesNeeded = maxVotes
        self.voteType = voteType
    }
    
    init (comparisonId: String? = nil, timestamp: Date, totalVoteNeeded: Int, voteType: VotingSelection, image1Url: String, image2Url: String, image1VoteCount: Int, image2VoteCount: Int){
        
        self.comparisonId = comparisonId
        self.timestamp = timestamp
        self.totalVotesNeeded = totalVoteNeeded
        self.voteType = voteType
        self.image1Url = image1Url
        self.image2Url = image2Url
        self.image1VoteCount = image1VoteCount
        self.image2VoteCount = image2VoteCount
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
