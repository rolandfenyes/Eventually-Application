//
//  Map.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 10..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import MapKit

class MapLoader {
    private var map: MKMapView
    
    init(map: MKMapView){
        self.map = map
    }
    
    func showMap(coordinates: CLLocationCoordinate2D, animation: Bool, title: String, mapRange: Double) {
        let annotations = self.map.annotations
        if annotations.count > 0 {
            self.map.removeAnnotations(annotations)
        }
        
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
        self.map.addAnnotation(annotation)
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let span = MKCoordinateSpan(latitudeDelta: mapRange, longitudeDelta: mapRange)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        self .map.setRegion(region, animated: animation)
    }
}
