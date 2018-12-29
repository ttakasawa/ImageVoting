//
//  NetworkManager.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase
import FirebaseStorage
import FirebaseDatabase

protocol NetworkManager {
    //Communication with Firebase
    var firebaseDBConnection: DatabaseReference { get set }
    
    func fetchFirebase<T: Decodable>(endpoint: FirebaseEndpoint, completion: @escaping (_ result: T?, _ error: Error?) -> Void)
    func fetchAuth(endpoint: FirebaseEndpoint, completion: @escaping (_ id: String?, _ error: Error?) -> Void)
    func firebaseAtomicStore(endpoints: [FirebaseEndpoint], completion: @escaping ( _ success: Bool) -> Void)
    func uploadImageToStorage(endpoint: FirebaseEndpoint, completion: @escaping (_ URLs: String?, _ error: Error?) -> Void)
}


extension NetworkManager {
    func fetchFirebase<T: Decodable>(endpoint: FirebaseEndpoint, completion: @escaping (_ result: T?, _ error: Error?) -> Void) {
        
        var realtimeDBPath: DatabaseReference!
        
        if let path = endpoint.path {
            realtimeDBPath = self.firebaseDBConnection.child(path)
        }else{
            realtimeDBPath = self.firebaseDBConnection
        }
        
        if let body = endpoint.body {
            //update
            if (endpoint.type == EndpointsType.storeSingleObject){
                
                realtimeDBPath.setValue(body)
                
                if let storedData = body as? T{
                    completion(storedData, nil)
                }else{
                    completion(nil, nil)
                }
                
            }
        }else{
            //query
            if (endpoint.type == EndpointsType.querySingleObject){
                
                realtimeDBPath.observeSingleEvent(of: .value, with: { snapshot in
                    
                    guard let value = snapshot.value else { return }
                    
                    do {
                        let model = try FirebaseDecoder().decode(T.self, from: value)
                        completion(model, nil)
                    } catch let error {
                        completion(nil, error)
                    }
                    
                })
                
            }else if endpoint.type == EndpointsType.queryList {
                
                realtimeDBPath.observe(.childAdded) { (snapshot) in
                    let key = snapshot.key
                    
                    if let messageKey = key as? T {
                        completion(messageKey, nil)
                    }else{
                        completion(nil, nil)
                    }
                }
                completion(nil, nil)
                
            }else if endpoint.type == EndpointsType.queryListWithLimit {
                
                realtimeDBPath.queryLimited(toLast: 15).observe(.childAdded) { (snapshot) in
                    let key = snapshot.key
                    
                    if let messageKey = key as? T {
                        completion(messageKey, nil)
                    }else{
                        completion(nil, nil)
                    }
                }
                completion(nil, nil)
            }
        }
    }
    
    func fetchAuth(endpoint: FirebaseEndpoint, completion: @escaping (_ id: String?, _ error: Error?) -> Void) {
        
    }
    
    func firebaseAtomicStore(endpoints: [FirebaseEndpoint], completion: @escaping ( _ success: Bool) -> Void) {
        
        let ref = Global.network.firebaseDBConnection
        var fanoutObj: [String: Any] = [:]
        for i in 0..<endpoints.count{
            
            guard let path = endpoints[i].path else { return }
            guard let body = endpoints[i].body else { return }
            
            fanoutObj[path] = body
        }
        
        ref.updateChildValues(fanoutObj) { (error, ref) in
            if error != nil {
                completion(false)
            }else{
                completion (true)
            }
        }
        
    }
    
    func uploadImageToStorage(endpoint: FirebaseEndpoint, completion: @escaping (_ URLs: String?, _ error: Error?) -> Void){
        
        let path = endpoint.path
        guard let body = endpoint.body as? Data else { return }
        
        let storageRef = Storage.storage().reference().child(path!)
        
        storageRef.putData(body, metadata: nil) { (metadata, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                
                let stringUrl = url?.absoluteString
                completion(stringUrl, nil)
                
            })
        }
        
    }
    
    
}


//
//func getMessages(user: UserData, count: Int?, completion: @escaping ([Message]) -> Void) {
//    var messages: [Message] = []
//
//    //NOTE: count is set to 15 in .retrieveMessageKey -> Need fix here
//    self.fetchFirebase(endpoint: MessageEndpoints.retrieveMessageKey(user: user, count: count)) { (key: String?, error: Error?) in
//
//        if key != nil {
//            self.fetchFirebase(endpoint: MessageEndpoints.getMessages(key: key!)) { (message: Message?, error: Error?) in
//
//                if (error != nil) { return }
//
//                if let message = message {
//                    if message.fromId == Global.network.user?.id {
//                        message.sender = Global.network.currentSender!
//                    }else {
//                        message.sender = Sender(id: message.fromId, displayName: "Gwen")
//                    }
//
//                    messages.append(message)
//                    completion(messages)
//                }
//
//            }
//        }else{
//            completion(messages)
//        }
//    }
//    //completion(messages)
//}
//
