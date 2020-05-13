//
//  EncodableEvent.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 29..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import MapKit

struct CodableEvent : Codable {
    
    let name: String
    let description: String
    let starttime: String
    let endtime: String
    let partlimit: String
    let part: String
    let lon: Double
    let lat: Double
    let photo: String?
    let visibility: String
    
    init(name: String, description: String, starttime: String, endtime: String, partlimit: String, part: String, visibility: String, location: CLLocationCoordinate2D) {
        self.name = name
        self.description = description
        self.starttime = starttime
        self.endtime = endtime
        self.partlimit = partlimit
        self.part = part
        self.visibility = visibility
        self.lon = location.longitude
        self.lat = location.latitude
        self.photo = nil
    }
    
}
