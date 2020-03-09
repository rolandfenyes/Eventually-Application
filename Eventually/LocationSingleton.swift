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
    
    private var coordinates: CLLocationCoordinate2D?
    private var baseLocationText: String

    
    private static var sharedLocation: LocationSingleton = {
        let locationManager = LocationSingleton(baseLocationText: "Budapest")
        return locationManager
    }()
    
    private init(baseLocationText: String) {
        self.baseLocationText = baseLocationText
    }

    func getCoordinates() -> CLLocationCoordinate2D {
        return coordinates!
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
    
    class func shared() -> LocationSingleton {
        return sharedLocation
    }
    
}
