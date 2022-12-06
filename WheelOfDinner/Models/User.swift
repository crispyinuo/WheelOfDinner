//
//  User.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/4/22.
//

import Foundation
import FirebaseFirestore

class User{
    
    let db = Firestore.firestore()
    // User Singleton to store the login user
    public static let shared = User()
    
    var isLoggedIn = false
    //Default coordinates: USC campus
    var latitude: Double = 34.0224
    var longitude: Double =  -118.2851
    
    var uid: String = ""
    var username: String = ""
    //Store a list of id of business
    var likeList: [String] = []
    var resultList: [String] = []
    
    func initializeUser(username: String, uid: String){
        self.username = username
        self.uid = uid
        self.isLoggedIn = true
        db.collection("users").document(uid).setData(["username":username, "uid": uid, "likeList": likeList, "resultList": resultList, "latitude": latitude, "longitude": longitude])
   }
    
    func FetchData(uid: String){
        print("I got here in user")
        let docRef = db.collection("users").document(uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                    if let data = data {
                        self.username = data["username"] as? String ?? ""
                        self.latitude = data["latitude"] as? Double ?? 34.0224
                        self.longitude = data["longitude"] as? Double ?? -118.2851
                        self.likeList = data["likeList"] as? [String] ?? []
                        self.resultList = data["resultList"] as? [String] ?? []
                    }
                print("Fetching data from: \(self.username)")
            } else {
                print("User does not exist")
            }
        }
    }
}
