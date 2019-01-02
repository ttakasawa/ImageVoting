//
//  ImagePostable.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePostable {
    var maxVoteCount: Int { get }
    func createComparisonRequest(user: UserData, voteType: VotingSelection, image1: UIImage, image2: UIImage, completion: @escaping (_ record: ComparisonRecord?, _ error: Error?) -> Void)
    func uploadImages(userId: String, comparison: ComparisonRecord, completion: @escaping (_ suceess: Bool, _ error: Error?) -> Void)
}

extension ImagePostable where Self: HTTPRequestHandler {
    func uploadImages(userId: String, comparison: ComparisonRecord, completion: @escaping (_ suceess: Bool, _ error: Error?) -> Void) {
        
        self.httpRequest(endpoint: PublicPostEndpoint.postComparison(userId: userId, comparison: comparison)) { (_ success: Bool, _ error: Error?) in
            
            completion(success, error)
        }
    }
}

extension ImagePostable where Self: NetworkManager {
    
    func createComparisonRequest(user: UserData, voteType: VotingSelection, image1: UIImage, image2: UIImage, completion: @escaping (_ record: ComparisonRecord?, _ error: Error?) -> Void) {
        
        var firstEndpoint: StorageEndpoint!
        var secondEndpoint: StorageEndpoint!
        
        if voteType == .publicSelection {
            firstEndpoint = StorageEndpoint.PublicImagePost(image: image1, user: user, postClientId: NSUUID().uuidString)
        }else{
            firstEndpoint = StorageEndpoint.PrivateImagePost(image: image1, user: user, postClientId: NSUUID().uuidString)
        }
        
        
        self.uploadImageToStorage(endpoint: firstEndpoint) { (stringUrl1, error) in
            
            if error != nil {
                print(error ?? "Error uploading the first image")
            }
            
            guard let stringUrl1 = stringUrl1 else {
                completion(nil, error)
                return
            }
            
            if voteType == .publicSelection {
                secondEndpoint = StorageEndpoint.PublicImagePost(image: image2, user: user, postClientId: NSUUID().uuidString)
            }else{
                secondEndpoint = StorageEndpoint.PrivateImagePost(image: image2, user: user, postClientId: NSUUID().uuidString)
            }
            
            self.uploadImageToStorage(endpoint: secondEndpoint) { (stringUrl2, error) in
                
                guard let stringUrl2 = stringUrl2 else {
                    completion(nil, error)
                    return
                }
                
                let record = ComparisonRecord(image1Url: stringUrl1, image2Url: stringUrl2, maxVotes: self.maxVoteCount, voteType: voteType)
                
                completion(record, nil)
                
            }
        }
    }
    
    
}
