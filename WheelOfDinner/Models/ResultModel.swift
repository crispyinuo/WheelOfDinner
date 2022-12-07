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
    let BASE_URL =  "https://api.yelp.com"
    public var businesslist:[Business] = []
    public var likelist:[Business] = []
    // keep track of whether the like list/business list has changed so that we don't need to reload it everytime
    public var likeListChanged : Bool = true
    public var likeListLoad: Bool = false
    public var startFirstLoad : Bool = false
    public var endFirstLoad: Bool = false
    public var businessListChanged : Bool = false
    public let loadList = DispatchGroup()
    init(){
    }
    
    // Get a list of businesses around a location
    func getBusinessWithLocation(location: String, onSuccess: @escaping ([Business]) -> Void) {
        businessListChanged = true
        if let url = URL(string: "\(BASE_URL)/v3/businesses/search?location=\(location)&sort_by=best_match&limit=\(RESULT_COUNT)"){
            var urlRequest = URLRequest(url:url)
            urlRequest.addValue("Bearer \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with:urlRequest){ [self]
                data, response, error in
                if let data = data{
                    // Data that contains our business array
                    do {
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
    
    // Get a single business by id
    func getBusinessById(BusinessId: String, onSuccess: @escaping (Business) -> Void){
        if let url = URL(string: "\(BASE_URL)/v3/businesses/\(BusinessId)"){
            var urlRequest = URLRequest(url:url)
            urlRequest.addValue("Bearer \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with:urlRequest){ data, response, error in
                if let data = data{
                    // Data that contains our business
                    do {
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
    
    // Get a list of business by coordinates
    func getBusinessByCoordinates(latitude: Double, longitude: Double, onSuccess: @escaping ([Business]) -> Void) {
        businessListChanged = true
        if let url = URL(string: "\(BASE_URL)/v3/businesses/search?latitude=\(String(format: "%.3f", latitude))&longitude=\(String(format: "%.3f",longitude))&sort_by=best_match&limit=\(RESULT_COUNT)"){
            var urlRequest = URLRequest(url:url)
            urlRequest.addValue("Bearer \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with:urlRequest){ [self]
                data, response, error in
                if let data = data{
                    // Data that contains our business array
                    do {
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
    
    func firstloadLikeList(){
        startFirstLoad = true
        let loadQueue = DispatchQueue.global(qos: .background)
        let semaphore = DispatchSemaphore(value: 2)
        print("start first reloading")
        self.likelist = []
        for bid in User.shared.likeList {
            loadQueue.async(group: loadList){
                semaphore.wait()
                self.getBusinessById(BusinessId: bid){business in
                    print("Done with \(business.name ?? "nope")")
                    Thread.sleep(forTimeInterval: 0.5)
                    semaphore.signal()
                }
            }
        }
//        loadList.wait()
//        loadList.notify(queue: DispatchQueue.main, execute: {
//            print("finish first reloading")
//            // Everytime after we load like list, set likeListChanged to false
//                self.endFirstLoad = true
//                print("Finished all requests.")
//            })        loadList.wait()
//        loadList.notify(queue: DispatchQueue.main, execute: {
//            print("finish first reloading")
//            // Everytime after we load like list, set likeListChanged to false
//                self.endFirstLoad = true
//                print("Finished all requests.")
//            })

    }
    
    struct SearchResult : Decodable{
        let businesses : [Business]
    }
    
    func getBusinessCount() -> Int{
        return businesslist.count
    }
    
    func LogOut(){
        // Set default values for result model when a user logout
        businesslist = []
        likelist = []
        likeListChanged = true
        likeListLoad = false
        startFirstLoad = false
        endFirstLoad = false
        businessListChanged  = false
    }
}
