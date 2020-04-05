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

    //MARK: - Variables
    @IBOutlet weak var myMapView: MKMapView!
    private var map: MapLoader!
    @IBOutlet weak var foundButton: UIButton!
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        map = MapLoader(map: myMapView)
        if LocationSingleton.shared().isLocationAlreadyLoaded() {
            activeSearch(search: LocationSingleton.shared().getText())
        }
        setFoundButtonInvisible()
    }
    
    //MARK: - Set up Search Button
    
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
    
    //MARK: - Searching on Map
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
                let latitude = response!.boundingRegion.center.latitude
                let longitude = response!.boundingRegion.center.longitude
                self.map.showMap(coordinates: response!.boundingRegion.center.self, animation: true, title: search, mapRange: 0.1)
                
                self.convertLatLongToAddress(latitude: latitude, longitude: longitude)
                }
        }
    }
    
    //MARK: - Convert coordinates to Address
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
            self.setFoundButtonVisible()
        })

    }
    
    //MARK: - Found Button
    
    func setFoundButtonVisible() {
        self.foundButton.isHidden = false
        self.foundButton.isEnabled = true
    }
    
    func setFoundButtonInvisible() {
        self.foundButton.isHidden = true
        self.foundButton.isEnabled = false
    }
    @IBAction func foundButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
} // end of the class
