//
//  GlobalNetwork.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/15/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import Firebase

protocol NetworkInterface: ImageVotable, ImagePostable, UserNetwork {}
protocol NetworkLayer: NetworkManager, HTTPRequestHandler, NetworkInterface{}
protocol GlobalNetwork: NetworkLayer, ThemeSelectable, ImageLoadable {}

struct Global {
    
    static var theme: ColorTheme{
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: defaultsKeys.colorThemeKey), stringOne == "light" {
            return ColorTheme.light
        }
        return ColorTheme.dark
    }
    
    class Network: GlobalNetwork {
        var baseURL: URL {
            return URL(string: "https://us-central1-imagevoting-e0ac5.cloudfunctions.net/app")!
        }
        var maxVoteCount: Int
        var firUserId: String?
        var user: UserData?
        var firebaseDBConnection: DatabaseReference
        var appTheme: ColorTheme
        
        init (){
            //initialize
            self.appTheme = Global.theme
            self.firebaseDBConnection = Database.database().reference(fromURL: "https://imagevoting-e0ac5.firebaseio.com/")
            self.firUserId = Auth.auth().currentUser?.uid
            self.maxVoteCount = 10
        }
        
        func setTheme(theme: ColorTheme) {
            let defaults = UserDefaults.standard
            defaults.set(theme, forKey: defaultsKeys.colorThemeKey)
        }
    }
    class DemoNetwork: GlobalNetwork {
        var baseURL: URL {
            return URL(string: "https://us-central1-imagevoting-e0ac5.cloudfunctions.net/app")!
        }
        var maxVoteCount: Int
        var firUserId: String?
        var user: UserData?
        var firebaseDBConnection: DatabaseReference
        var appTheme: ColorTheme
        
        init (){
            //initialize
            self.appTheme = Global.theme
            self.firebaseDBConnection = Database.database().reference(fromURL: "https://imagevoting-e0ac5.firebaseio.com/")
            self.maxVoteCount = 10
        }
    }
    
    static var network = Network()
}



