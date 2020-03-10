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
    
    //MARK: - Variables
    private var eventName: String
    private var eventLocation: CLLocationCoordinate2D
    private var address: String
    private var numberOfPeople: String // int
    private var shortDescription: String
    private var dateOfEvent: String
    private var publicity: String
    private var image: UIImage?
    
    //MARK: - Init
    init(eventName: String, eventLocation: CLLocationCoordinate2D, numberOfPeople: String, shortDescription: String, dateOfEvent: String, publicity: String, image: UIImage?, address: String) {
        self.eventName = eventName
        self.eventLocation = eventLocation
        self.numberOfPeople = numberOfPeople
        self.shortDescription = shortDescription
        self.dateOfEvent = dateOfEvent
        self.publicity = publicity
        self.image = image
        self.address = address
    }
    
    //MARK: - Getters
    func getName() -> String {
        return eventName
    }
    
    func getEventName() -> String {
        return self.eventName
    }
    func getEventLocation() -> CLLocationCoordinate2D {
        return self.eventLocation
    }
    func getGuests() -> String {
        return self.numberOfPeople
    }
    func getDescription() -> String {
        return self.shortDescription
    }
    func getDate() -> String {
        return self.dateOfEvent
    }
    func getPub() -> String {
        return self.publicity
    }
    func getImage() ->UIImage {
        return self.image!
    }
    func getAddress() -> String {
        return self.address
    }
}
