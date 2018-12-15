//
//  GlobalNetwork.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

protocol GlobalNetwork: NetworkManager, ImageVotable, ImagePostable {}

struct Global {
    class Network: GlobalNetwork {
        init (){
            //initialize
        }
    }
    class DemoNetwork: GlobalNetwork {
        init (){
            //initialize
        }
    }
    
    var network = Network()
}
