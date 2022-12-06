//
//  MapViewController.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 11/6/22.
//

import UIKit
import MapKit
import CoreLocation
import FloatingPanel

class MapViewController: UIViewController, CLLocationManagerDelegate, FloatingPanelControllerDelegate, UISearchResultsUpdating{

    let sharedModel = ResultModel.shared
    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    let searchVC = UISearchController(searchResultsController: ResultViewController())
    let fpc = FloatingPanelController()
    let thisUser = User.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Floating Panel
        fpc.delegate = self
        
        guard let contentVC = storyboard?.instantiateViewController(identifier: "fpc_content") as? MapContentViewController else{
            return
        }
        fpc.set(contentViewController: contentVC)
       // fpc.addPanel(toParent: self)
        searchVC.searchBar.backgroundColor = UIColor(hex: Constants.Color.backgroundColor)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        manager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fpc.addPanel(toParent: self)
        self.view.bringSubviewToFront(fpc.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fpc.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    //    manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        if let location = locations.first{
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation){
//      set current location to user
        thisUser.setLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: thisUser.latitude, longitude: thisUser.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty,
        let resultsVC = searchController.searchResultsController as? ResultViewController else{
            return
        }
        
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query){result in
            switch result{
            case .success(let places):
                resultsVC.update(with: places)
                print(places)
            case .failure (let error):
                print(error)
            }
        }
    }
}

extension MapViewController: ResultViewControllerDelegate{
    func didTapPlace(with coordinates: CLLocationCoordinate2D){
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        
        // Remove all map pins
        mapView.removeAnnotations(mapView.annotations)
        
        // Add a map pin
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
        // everytime location changed, set businessListChanged to true
        sharedModel.businessListChanged = true
        // Updating restaurants in UI Floating Panel & User location
        thisUser.setLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}

