//
//  ResultModel.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/4/22.
//

import Foundation

class ResultModel{
    public static let shared = ResultModel()
    let RESULT_COUNT = 20
    let ACCESS_KEY = "K_zbPOb9xIg8fO4E2JW3krUcgHb0tsdcZwF978bAspNhLZPy0scTjSxww1seM85pHg4jPkSQqgFV6WWYJr7NUlA4pz_dlV7kLbbsFdfHiK6M7fmVenygD9QwBGdoY3Yx"
    var location = "NYC"
    let BASE_URL =  "https://api.yelp.com"
    public var businesslist:[Business] = []
    public var likelist:[Business] = []
    init(){
}
    
    func getBusiness(onSuccess: @escaping ([Business]) -> Void) {
//        if let url = URL(string: "\(BASE_URL)/v3/businesses/search?location=\(location)&sort_by=best_match&limit=\(RESULT_COUNT)"){
        if let url = URL(string: "\(BASE_URL)/v3/businesses/search?location=\(location)&sort_by=best_match&limit=\(RESULT_COUNT)"){
            var urlRequest = URLRequest(url:url)
            urlRequest.addValue("Bearer \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with:urlRequest){ [self]
                data, response, error in
                if let data = data{
                    // Data that contains our image JSON
                    do {
                       // let decoder = JSONDecoder()
                        let result = try JSONDecoder().decode(SearchResult.self, from: data)
                        self.businesslist = result.businesses
                        onSuccess(self.businesslist)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func getBusinessById(BusinessId: String, onSuccess: @escaping (Business) -> Void){
        if let url = URL(string: "\(BASE_URL)/v3/businesses/\(BusinessId)"){
            var urlRequest = URLRequest(url:url)
            urlRequest.addValue("Bearer \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with:urlRequest){ data, response, error in
                if let data = data{
                    // Data that contains our image JSON
                    do {
                       // let decoder = JSONDecoder()
                        let singleResult = try JSONDecoder().decode(Business.self, from: data)
                        self.likelist.append(singleResult)
                        onSuccess(singleResult)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
//    func getBusinessesByIds(BusinessIdList: [String], completion: @escaping ([Business]) -> Void){
//        //likelist = []
//        print("im here getting bussinesses by ids")
//        for uid in BusinessIdList {
//            self.getBusinessById(BusinessId: uid){ business in
//                    print("adding business \(business.name!)")
//            }
//        }
//        completion(self.likelist)
////        print("templistcount: \(templikelist.count) Idcount: \(BusinessIdList.count)")
////        if(BusinessIdList.count == templikelist.count){
////            likelist = templikelist
////            onSuccess(likelist)
////        }
//        //onSuccess(likelist)
//    }
    
    func getBusinessByCoordinates(latitude: Double, longitude: Double, onSuccess: @escaping ([Business]) -> Void) {
        if let url = URL(string: "\(BASE_URL)/v3/businesses/search?latitude=\(String(format: "%.3f", latitude))&longitude=\(String(format: "%.3f",longitude))&sort_by=best_match&limit=\(RESULT_COUNT)"){
            var urlRequest = URLRequest(url:url)
            urlRequest.addValue("Bearer \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with:urlRequest){ [self]
                data, response, error in
                if let data = data{
                    // Data that contains our image JSON
                    do {
                       // let decoder = JSONDecoder()
                        let result = try JSONDecoder().decode(SearchResult.self, from: data)
                        self.businesslist = result.businesses
                        onSuccess(self.businesslist)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    struct SearchResult : Decodable{
        let businesses : [Business]
    }
    
    func getBusinessCount() -> Int{
        return businesslist.count
    }
    
    func setLocation(_ location: String ) -> Void{
        self.location = location
    }
}
