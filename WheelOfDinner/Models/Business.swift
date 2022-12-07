//
//  Business.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/4/22.
//

import Foundation

struct Business: Codable {
    let rating: Double?
    let price: String?
    let id: String?
    let categories: [Category]?
    let review_count: Int?
    let name: String?
    let url: String?
    let coordinates: Coordinates?
    let image_url: String?
    let location: Location?
    let distance: Double?

//    enum CodingKeys: String, CodingKey {
//        case rating, price, id, categories
//        case reviewCount = "review_count"
//        case name, url, coordinates
//        case imageURL = "image_url"
//        case location
//    }
}

// MARK: - Category
struct Category: Codable {
    let alias, title: String?
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: Double?
}

// MARK: - Location
struct Location: Codable {
    let city, country, address2, address3: String?
    let state, address1, zipCode: String?

    enum CodingKeys: String, CodingKey {
        case city, country, address2, address3, state, address1
        case zipCode = "zip_code"
    }
}
