//
//  ImageVotable.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

protocol ImageVotable {
    func getComparison(voteType: VotingSelection)
    func setResult(id: String, selected: ImageSelection)
}

extension ImageVotable where Self: NetworkManager {
    
    func getComparison(voteType: VotingSelection) {
        if voteType == .privateSelection {
            //Id is necessary (It was requested from particular user)
        }else{
            //choose randomly from Public
        }
    }
    
    func setResult(id: String, selected: ImageSelection) {
        //set result in Firebase
        //increment should be done on server side
    }
}
