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
    private var startDate: String
    private var endDate: String
    private var publicity: String
    private var image: UIImage?
    private var joined: Bool! = false
    
    //MARK: - Init
    init(eventName: String, eventLocation: CLLocationCoordinate2D, numberOfPeople: String, shortDescription: String, startDate: String, endDate: String, publicity: String, image: UIImage?, address: String) {
        self.eventName = eventName
        self.eventLocation = eventLocation
        self.numberOfPeople = numberOfPeople
        self.shortDescription = shortDescription
        self.startDate = startDate
        self.endDate = endDate
        self.publicity = publicity
        self.image = image
        self.address = address
    }
    
    func setJoined(status: Bool) {
        self.joined = status
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
    func getStartDate() -> String {
        return self.startDate
    }
    func getEndDate() -> String {
        return self.endDate
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
    func getIsJoined() -> Bool {
        return self.joined
    }
    func isPublic() -> Bool {
        if (self.publicity == "Privát") {
            return false
        }
        else {
            return true
        }
    }
}