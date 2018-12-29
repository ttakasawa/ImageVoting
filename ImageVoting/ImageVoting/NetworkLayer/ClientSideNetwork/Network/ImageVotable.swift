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
    func vote(userId: String, postId: String, completion: @escaping (_ success: Bool) -> Void)
    
    func getPublicComparison (userId: String, completion: @escaping (_ posts: [ComparisonRecord]) -> Void)
}

extension ImageVotable where Self: NetworkManager {
    
    func getPublicComparison (userId: String, completion: @escaping (_ posts: [ComparisonRecord]) -> Void) {
        
        var comparisons: [ComparisonRecord] = []
        
        self.fetchFirebase(endpoint: PublicVoteEndpoint.getUserVotableTableKeys(userId: userId)) { (_ key: String?, _ error: Error?) in
            
            if key != nil {
                self.fetchFirebase(endpoint: PostEndpoint.getPosts(postId: key!), completion: { (result: ComparisonRecord?, error: Error?) in
                    if error != nil {
                        return
                    }
                    
                    if result != nil {
                        comparisons.append(result!)
                        completion(comparisons)
                    }
                })
            }else{
                completion(comparisons)
            }
            
        }
    }
    
    func getComparison(voteType: VotingSelection) {
        if voteType == .privateSelection {
            //Id is necessary (It was requested from particular user)
        }else{
            
            //choose randomly from Public
            
        }
        
        
    }
    
    
    
    func vote(userId: String, postId: String, completion: @escaping (_ success: Bool) -> Void) {
        
        //MustDo: Consider server side
        
        self.fetchFirebase(endpoint: PublicVoteEndpoint.getCounter(postId: postId)) { (counter: Int?, error: Error?) in
            
            guard let counter = counter else {
                completion(false)
                return
            }
            
            let endpoints = [PublicVoteEndpoint.increment(postId: postId, counter: counter + 1), PublicVoteEndpoint.removePostIdFromUserTable(userId: userId, postId: postId), PublicVoteEndpoint.removeUserIdFromPostTable(postId: postId, userId: userId)]
            
            self.firebaseAtomicStore(endpoints: endpoints, completion: { (success) in
                completion(success)
            })
        }
        
        
    }
}
