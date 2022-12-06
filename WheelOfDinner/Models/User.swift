//
//  User.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/4/22.
//

import Foundation

class User: Codable, Identifiable{
    
    //Default coordinates: USC campus
    var latitude: Double = 34.0224
    var longitude: Double =  -118.2851
    
    var uid: String = ""
    //Store a list of id of business
    var likeList: [String] = []
    var username: String = ""
    var resultList: [String] = []
    
   init(username: String, uid: String){
        self.username = username
        self.uid = uid
   }
}
