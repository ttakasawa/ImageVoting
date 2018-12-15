//
//  ImagePostable.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

protocol ImagePostable {
    func uploadImages(comparison: ComparisonRecord)
}

extension ImagePostable where Self: NetworkManager {
    func uploadImages(comparison: ComparisonRecord) {
        
    }
}
