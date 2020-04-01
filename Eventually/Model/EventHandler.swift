//
//  EventHandler.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 03. 10..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation

class EventHandler: MyObserverForEventList {
    
    private var events: [Event] = []
    
    class func shared() -> EventHandler {
        return eventHandler
    }
    
    private static var eventHandler: EventHandler = {
        let eventManager = EventHandler()
        return eventManager
    }()
    
    private override init() {
    }
    
    func addEvent(event: Event) {
        events.append(event)
        notify()
        print("event added")
    }
    
    func getEvents() -> [Event] {
        return events
    }
    
}
