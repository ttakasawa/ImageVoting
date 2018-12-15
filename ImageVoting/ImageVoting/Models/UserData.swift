//
//  UserData.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

class UserData {
    
    var userId: String
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    
    var comparisonRecords: [ComparisonRecord]?
    var points: Int
    
    init (userId: String) {
        self.userId = userId
        self.points = 0
    }
    
    func setPoints(pts: Int) -> Bool {
        if pts > 0 {
            self.points = self.points + pts
        } else {
            if self.points < pts {
                return false
            }else{
                self.points = self.points - pts
            }
        }
        return true
    }
}

