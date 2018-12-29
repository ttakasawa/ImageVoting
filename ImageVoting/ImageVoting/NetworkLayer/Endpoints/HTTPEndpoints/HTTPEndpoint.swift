//
//  HTTPEndpoint.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/24/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

protocol HTTPEndpoint: FirebaseEndpoint {
    var parameters: [String : String]? { get }
    var method: httpRequestType { get }
}


enum httpRequestType {
    case post
    case get
}
