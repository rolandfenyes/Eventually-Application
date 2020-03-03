//
//  NewEventHandler.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 03..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import UIKit

class NewEventHandler {
    
    private static var eventsInList = [Event]()
    
    public static func Instance(eventName: String, eventLocation: String, numberOfPeople: String, shortDescription: String, dateOfEvent: String, publicity: String, image: UIImage?) {
        let event = Event(eventName: eventName, eventLocation: eventLocation, numberOfPeople: numberOfPeople, shortDescription: shortDescription, dateOfEvent: dateOfEvent, publicity: publicity, image: image)
        eventsInList.append(event)
    }
    
    private init(event: Event) {
        
    }
    
    static func getEventsFromList() -> [Event] {
        return eventsInList
    }
    
}
