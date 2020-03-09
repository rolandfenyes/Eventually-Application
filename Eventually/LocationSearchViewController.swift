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
        print("Hát elkezdődött...")
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.isUserInteractionEnabled = false
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
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
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                self.myMapView.addAnnotation(annotation)
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                
                self .myMapView.setRegion(region, animated: true)
                
                self.convertLatLongToAddress(latitude: latitude, longitude: longitude)
                
                
                //LocationSingleton.shared().setLocation(coordinates: coordinate, text: searchBar.text!)
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

            // Location name
            if let locationName = placeMark.location {
                print(locationName)
            }
            // Street address
            if let street = placeMark.thoroughfare {
                print(street)
                locationText += street
            }
            // City
            if let city = placeMark.subAdministrativeArea {
                print(city)
                locationText += "/ " + city
            }
            // Zip code
            if let zip = placeMark.isoCountryCode {
                print(zip)
                locationText += "/ " + zip
            }
            // Country
            if let country = placeMark.country {
                print(country)
                locationText += "/ " + country
            }
            
            
            LocationSingleton.shared().setLocation(coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), text: locationText)
        })

    }
    
}
