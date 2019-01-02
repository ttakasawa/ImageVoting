//
//  UserNetwork.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/16/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol UserNetwork {
    
    var user: UserData? { get set }
    var firUserId: String? { get set }
    
    func createUser(email: String, password: String, firstName: String, lastName: String, completion: @escaping (_ user: UserData?) -> Void)
    func login(email: String, password: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    func signInAnonymously(completion: @escaping (_ user: UserData?) -> Void)
    func logout()
    func updateUser(user: UserData, completion: @escaping (_ error: Error?) -> Void)
    func queryUser(userId: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    
    func queryPastResults(user: UserData, completion: @escaping (_ results: [ComparisonRecord]) -> Void)
    
}


extension UserNetwork where Self: NetworkManager {
    
    func createUser(email: String, password: String, firstName: String, lastName: String, completion: @escaping (_ user: UserData?) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            guard let firUser = authResult?.user else {
                print("authResult?.user error")
                return
            }
            
            let signedInUser = UserData(userId: firUser.uid)
            signedInUser.setInitialValues(firstName: firstName, lastName: lastName, email: email, password: password)
            
            self.updateUser(user: signedInUser, completion: { (error) in
                if (error == nil) {
                    completion(signedInUser)
                } else {
                    completion(nil)
                }
                
            })
        }
        
    }
    
    func signInAnonymously(completion: @escaping (_ user: UserData?) -> Void) {
        Auth.auth().signInAnonymously() { (authResult, error) in
            
            if authResult != nil {
                
                let user = authResult!.user
                let uid = user.uid
                let signedInUser = UserData(userId: uid)
                signedInUser.setInitialValues(firstName: "Anonymous", lastName: "User")
                
                self.updateUser(user: signedInUser, completion: { (error) in
                    
                    if (error == nil) {
                        completion(signedInUser)
                    } else {
                        completion(nil)
                    }
                    
                })
            }
        }
    }
    
    func signInWithFacebook(){
        
    }
    
    func login(email: String, password: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let user = user else { return }
            let userId = user.user.uid
            
            self.queryUser(userId: userId, completion: { (user, error) in
                completion(user, error)
            })
        }
    }
    
    
    func logout(){
        try! Auth.auth().signOut()
        //Auth.auth().currentUser = nil
    }
    
    func updateUser(user: UserData, completion: @escaping (_ error: Error?) -> Void){
        
        self.fetchFirebase(endpoint: UserEndpoint.updateUser(userId: user.userId, user: user)) { (user: UserData?, error: Error?) in
            completion(error)
        }
    }
    
    func queryUser(userId: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void){
        
        self.fetchFirebase(endpoint: UserEndpoint.queryUser(userId: userId)) { (user: UserData?, error: Error?) in
            completion(user, error)
        }
        
    }
    
    
    func queryPastResults(user: UserData, completion: @escaping (_ results: [ComparisonRecord]) -> Void) {
        
        var pastResults: [ComparisonRecord] = []
        
        self.fetchFirebase(endpoint: UserEndpoint.getAllResultKeys(userId: user.userId)) { (_ key: String?, _ error: Error?) in
            
            if key != nil {
                
                self.fetchFirebase(endpoint: PostEndpoint.getPosts(postId: key!), completion: { (result: ComparisonRecord?, error: Error?) in
                    if error != nil {
                        return
                    }
                    
                    if result != nil {
                        pastResults.append(result!)
                        completion(pastResults)
                    }
                })
            }else{
                completion(pastResults)
            }
        }
        
    }
    
}



