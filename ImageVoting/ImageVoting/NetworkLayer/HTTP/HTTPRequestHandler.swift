//
//  HTTPRequestHandler.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/24/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import Alamofire

protocol HTTPRequestHandler {
    var baseURL: URL { get }
    func httpRequest(endpoint: FirebaseEndpoint, completion: @escaping (_ success: Bool, _ error: Error?) -> Void)
}

extension HTTPRequestHandler {
    func httpRequest(endpoint: FirebaseEndpoint, completion: @escaping (_ success: Bool, _ error: Error?) -> Void){
        
        var httpMethod: HTTPMethod!
        guard let path = endpoint.path else { return }
        let url = self.baseURL.appendingPathComponent(path)
        
        if (endpoint.body as? [String : String]) != nil {
            httpMethod = HTTPMethod.post
        }else{
            httpMethod = HTTPMethod.get
        }
        
        Alamofire.request(url, method: httpMethod, parameters: endpoint.body as? [String : String] ?? nil)
            .validate(statusCode: 200..<300).responseString(){ response in
                print("in httpRequest")
                
                switch response.result {
                    
                case .success:
                    completion(true, response.error)
                    
                case .failure:
                    print(response.error ?? "Just error, ok?")
                    completion(false, response.error)

            }
            
        }
    }
}
