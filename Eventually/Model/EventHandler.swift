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
    }
    
    func setJoinForAnEvent(status: Bool, index: Int) {
        events[index].setJoined(status: status)
        notify()
    }
    
    func getEvents() -> [Event] {
        return events
    }
    
    func getExactEventIndex(event: Event) -> Int {
        var index = 0
        for varEvent in self.events {
            if event === varEvent {
                break
            }
            index += 1
        }
        return index
    }
    
}
