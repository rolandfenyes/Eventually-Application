//
//  Event.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 03..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Event {
    
    private var eventName: String
    private var eventLocation: CLLocationCoordinate2D
    private var numberOfPeople: String // int
    private var shortDescription: String
    private var dateOfEvent: String
    private var publicity: String
    private var image: UIImage?
    
    init(eventName: String, eventLocation: CLLocationCoordinate2D, numberOfPeople: String, shortDescription: String, dateOfEvent: String, publicity: String, image: UIImage?) {
        self.eventName = eventName
        self.eventLocation = eventLocation
        self.numberOfPeople = numberOfPeople
        self.shortDescription = shortDescription
        self.dateOfEvent = dateOfEvent
        self.publicity = publicity
        self.image = image
    }
    
    func getName() -> String {
        return eventName
    }
}
