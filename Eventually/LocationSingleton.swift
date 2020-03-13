//
//  LocationSingleton.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 09..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import MapKit

class LocationSingleton : MyObserverForAddress {
    
    //MARK: - Variables
    private var coordinates: CLLocationCoordinate2D?
    private var baseLocationText: String
    private var locationAlreadyLoaded: Bool! = false
    
    //MARK: - Set up Singleton
    private static var sharedLocation: LocationSingleton = {
        let locationManager = LocationSingleton(baseLocationText: "Budapest")
        return locationManager
    }()
    
    private init(baseLocationText: String) {
        self.baseLocationText = baseLocationText
    }
    
    //MARK: - Functions

    func getCoordinates() -> CLLocationCoordinate2D? {
        return coordinates
    }
    func getText() -> String {
        return baseLocationText
    }
    
    func setLocation(coordinates: CLLocationCoordinate2D, text: String){
        self.coordinates = coordinates
        self.baseLocationText = text
        print(baseLocationText)
        notify()
    }
    
    func setLocationAlreadyLoadedTrue() {
        self.locationAlreadyLoaded = true
    }
    
    func isLocationAlreadyLoaded() -> Bool {
        return self.locationAlreadyLoaded
    }
    
    class func shared() -> LocationSingleton {
        return sharedLocation
    }
    
}
