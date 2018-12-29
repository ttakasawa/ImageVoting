//
//  UserData.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

class UserData: Codable {
    
    var userId: String
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var age: Int?
    
    var comparisonRecordKeys: [String]?
    var points: Int
    
    init (userId: String) {
        self.userId = userId
        self.points = 0
        self.comparisonRecordKeys = []
    }
    
    func setInitialValues(firstName: String, lastName: String, email: String? = nil, password: String? = nil) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        
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

