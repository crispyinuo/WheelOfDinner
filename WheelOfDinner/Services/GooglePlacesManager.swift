//
//  GooglePlacesManager.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/4/22.
//

import Foundation
import GooglePlaces

struct Place{
    let name: String
    let identifier: String
}

final class GooglePlacesManager{
    
   // let API_KEY = "AIzaSyDEvNoLoEdXGXdMAsy_7ZpRpWYaxvgGwQQ"
    
    static let shared = GooglePlacesManager()
    
    private let client = GMSPlacesClient.shared()
    
    private init(){
        
    }
    
    enum PlacesError: Error{
        case failedToFind
        case failedToGetCoordinates
    }
    
    public func findPlaces(query: String, completion: @escaping (Result<[Place], Error>) ->Void){
        let filter = GMSAutocompleteFilter()
    //    filter.types = []
     //   filter.countries =
        client.findAutocompletePredictions(
        fromQuery: query,
        filter: filter,
        sessionToken: nil
        ){ results, error in
            guard let results = results, error == nil else{
                completion(.failure(PlacesError.failedToFind))
                return
            }
            let places: [Place] = results.compactMap({
                Place(name: $0.attributedFullText.string, identifier: $0.placeID)
            })
            completion(.success(places))
        }
    }
    
    public func resolveLocation(
        for place: Place,
            completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void
    ){
        client.fetchPlace(fromPlaceID: place.identifier, placeFields: .coordinate, sessionToken: nil){
            googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else{
                completion(.failure(PlacesError.failedToGetCoordinates))
                return
            }
            let coordinate = CLLocationCoordinate2D(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            
            completion(.success(coordinate))
        }
    }
    
}
