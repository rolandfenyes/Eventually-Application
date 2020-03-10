//
//  LocationSearchViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 09..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LocationSingleton.shared().isLocationAlreadyLoaded() {
            activeSearch(search: LocationSingleton.shared().getText())
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.isUserInteractionEnabled = false
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        activeSearch(search: searchBar.text ?? "")
    }
    
    func activeSearch(search: String){
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        
        let searchRequest = MKLocalSearch.Request()
        
        searchRequest.naturalLanguageQuery = search
        LocationSingleton.shared().setLocationAlreadyLoadedTrue()
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start {
            (response, error) in
            
            activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if response == nil {
                print("Error")
            }
            else {
                let annotations = self.myMapView.annotations
                if annotations.count > 0 {
                    self.myMapView.removeAnnotations(annotations)
                }
                
                let latitude = response!.boundingRegion.center.latitude
                let longitude = response!.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                annotation.title = search
                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                self.myMapView.addAnnotation(annotation)
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                
                self .myMapView.setRegion(region, animated: true)
                
                self.convertLatLongToAddress(latitude: latitude, longitude: longitude)
                }
        }
    }
    
    
    func convertLatLongToAddress(latitude:Double,longitude:Double){

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        var locationText: String = ""
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            if let name = placeMark.name {
                locationText += name
            }
            
            if let locality = placeMark.locality {
                locationText += locality
            }
            
            LocationSingleton.shared().setLocation(coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), text: locationText)
        })

    }
    
}
