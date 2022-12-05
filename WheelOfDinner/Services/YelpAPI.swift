////
////  YelpAPI.swift
////  WheelOfDinner
////
////  Created by Yinuo Zhou on 11/6/22.
////
//
//import Foundation
//import CoreLocation
//import Combine
//
//let apiKey =  "K_zbPOb9xIg8fO4E2JW3krUcgHb0tsdcZwF978bAspNhLZPy0scTjSxww1seM85pHg4jPkSQqgFV6WWYJr7NUlA4pz_dlV7kLbbsFdfHiK6M7fmVenygD9QwBGdoY3Yx"
//
//struct YelpAPI{
//    // search term, user location
//    var search: (String, CLLocation, String?) -> AnyPublisher<[Business], Never>
//}
//
//extension YelpAPI{
//    static let live = YelpAPI{ term, location, cat in
//           // url component for yelp endpoint
//        var urlComponents = URLComponents(string: "https://api.yelp.com")!
//        urlComponents.path = "/v3/businesses/search"
//        urlComponents.queryItems = [
//            .init(name: "term", value: term),
//            .init(name: "longitude", value: String(location.coordinate.longitude)),
//            .init(name: "latitude", value: String(location.coordinate.latitude)),
//            .init(name: "catogories", value: cat)
//        ]
//        let url = urlComponents.url!
//        var request = URLRequest(url: url)
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        
//        // URL request and return [Businesses]
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .map(\.data)
//            .decode(type: SearchResult.self, decoder: JSONDecoder())
//            .map(\.businesses)
//            .replaceError(with: [])
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//    
//}
////struct SearchResult : Codable{
////    let businesses : [Business]
////}
////
////struct Business: Codable {
////    let rating: Double?
////    let price, phone, id: String?
////    let categories: [Category]?
////    let reviewCount: Int?
////    let name: String?
////    let url: String?
////    let coordinates: Coordinates?
////    let imageURL: String?
////    let location: Location?
////
////    enum CodingKeys: String, CodingKey {
////        case rating, price, phone, id, categories
////        case reviewCount = "review_count"
////        case name, url, coordinates
////        case imageURL = "image_url"
////        case location
////    }
////}
//
////// MARK: - Category
////struct Category: Codable {
////    let alias, title: String?
////}
////
////// MARK: - Coordinates
////struct Coordinates: Codable {
////    let latitude, longitude: Double?
////}
////
////// MARK: - Location
////struct Location: Codable {
////    let city, country, address2, address3: String?
////    let state, address1, zipCode: String?
////
////    enum CodingKeys: String, CodingKey {
////        case city, country, address2, address3, state, address1
////        case zipCode = "zip_code"
////    }
////}
