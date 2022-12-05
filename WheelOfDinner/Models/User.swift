//
//  User.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/4/22.
//

import Foundation

class User {
    public static let shared = User()
    
    //Default coordinates
    var latitude: Double = 34.0224
    var longitude: Double =  118.2851
    
    var uid: String = ""
    //Store a list of id of business
    var likeList: [String] = []
    var username: String = ""
    var resultList: [String] = []
    
    func setUser(uid: String, username: String){
        self.uid = uid
        self.username = username
    }
    
    func setLocation(latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func addToLikeList(_ businessId: String){
        likeList.append(businessId)
    }

}
