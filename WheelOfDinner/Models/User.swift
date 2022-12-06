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
        self.uid = uid
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
    
    func setLocation(latitude: Double, longitude: Double){
        if latitude >= -90 && latitude <= 90 && longitude <= 180 && longitude >= -180 && (latitude != self.latitude || longitude != self.longitude) {
            self.latitude = latitude
            self.longitude = longitude
            print("latitude: \(String(self.latitude)) longtitude: \(String(self.longitude))")
//            print("self.uid: \(self.uid)")
            let docRef = db.collection("users").document(self.uid)

            // Update the latitude and longitude of the user in Firebase
            docRef.updateData([
                "latitude": latitude,
                "longitude": longitude
            ]) { err in
                if let err = err {
                    print("Error updating location for user: \(err)")
                } else {
                    print("Location successfully updated")
                }
            }
        }else{
            print("Unvalid location")
        }
    }
    
    func addToLikeList(bid: String){
        if !likeList.contains(bid) {
            likeList.append(bid)
            let docRef = db.collection("users").document(self.uid)
            
            // Update the likeList of the user in Firebase
            docRef.updateData([
                "likeList": self.likeList
            ]) { err in
                if let err = err {
                    print("Error adding likeList for user: \(err)")
                } else {
                    print("LikeList successfully updated")
                }
            }
        } else {
            print("Restaurant already exists")
        }
    }
    
    func deleteFromLikeList(bid: String){
        if let idx = likeList.index(of: bid) {
            likeList.remove(at: idx)
            let docRef = self.db.collection("users").document(self.uid)
            
            // Update the likeList of the user in Firebase
            docRef.updateData([
                "likeList": self.likeList
            ]) { err in
                if let err = err {
                    print("Error deleting likeList for user: \(err)")
                } else {
                    print("LikeList successfully updated")
                }
            }
        }else{
            print("Restaurant does not exists")
        }
    }
    
}
