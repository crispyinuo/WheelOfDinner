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
    init(){
 
    }
    
    func readData (){

        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer K_zbPOb9xIg8fO4E2JW3krUcgHb0tsdcZwF978bAspNhLZPy0scTjSxww1seM85pHg4jPkSQqgFV6WWYJr7NUlA4pz_dlV7kLbbsFdfHiK6M7fmVenygD9QwBGdoY3Yx"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.yelp.com/v3/businesses/search?location=New%20York%20City&sort_by=best_match&limit=20")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
          }
        })

        dataTask.resume()
    }
    
    func getBusiness(onSuccess: @escaping ([Business]) -> Void) {
//        if let url = URL(string: "\(BASE_URL)/v3/businesses/search?location=\(location)&sort_by=best_match&limit=\(RESULT_COUNT)"){
        if let url = URL(string: "https://api.yelp.com/v3/businesses/search?location=New%20York%20City&sort_by=best_match&limit=20"){
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
