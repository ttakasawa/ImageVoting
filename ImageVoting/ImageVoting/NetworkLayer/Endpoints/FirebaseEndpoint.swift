//
//  FirebaseEndpoint.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import CodableFirebase

protocol FirebaseEndpoint {
    
    var path: String? { get }
    var body: Any? { get }
    var type: EndpointsType? { get }
    
    func toData<T: Encodable>(object: T) -> Any?
    
}

extension FirebaseEndpoint {
    func toData<T: Encodable>(object: T) -> Any? {
        let encoder = FirebaseEncoder()
        do{
            let jsonData = try encoder.encode(object)
            return jsonData // json body
        }catch{
            return nil
        }
    }
}


enum EndpointsType {
    case querySingleObject
    case storeSingleObject
    case httpRequest
    case queryList
    case queryListWithLimit
}
