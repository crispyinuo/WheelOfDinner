//
//  UserModel.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/5/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserModel: ObservableObject{
    public static let shared = UserModel()
    
    var thisUser: User?
    
    func fetchData(){
        
    }
    
//    func setUser(uid: String, username: String){
//        self.user.uid = uid
//        self.user.username = username
//    }
//
//    func setLocation(latitude: Double, longitude: Double){
//        self.user.latitude = latitude
//        self.user.longitude = longitude
//    }
//
//    func addToLikeList(_ businessId: String){
//        self.user.likeList.append(businessId)
//    }
    
}
