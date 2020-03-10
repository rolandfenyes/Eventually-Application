//
//  EventHandler.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 10..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation

class EventHandler {
    
    private var events: [Event] = []
    
    class func shared() -> EventHandler {
        return eventHandler
    }
    
    private static var eventHandler: EventHandler = {
        let eventManager = EventHandler()
        return eventManager
    }()
    
    private init() {
    }
    
    func addEvent(event: Event) {
        print("event added")
        events.append(event)
    }
    
    func getEvents() -> [Event] {
        return events
    }
    
}
