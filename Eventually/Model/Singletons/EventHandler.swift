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
    
    func editEvent(oldEvent: Event, modifiedEvent: Event) {
        let index = getExactEventIndex(event: oldEvent)
        events[index].setEventName(name: modifiedEvent.getEventName())
        events[index].setEventLocation(location: modifiedEvent.getEventLocation())
        events[index].setGuests(guests: modifiedEvent.getGuests())
        events[index].setDescription(desc: modifiedEvent.getDescription())
        events[index].setStartDate(date: modifiedEvent.getStartDate())
        events[index].setEndDate(date: modifiedEvent.getEndDate())
        events[index].setPub(pub: modifiedEvent.getPub())
        events[index].setImage(image: modifiedEvent.getImage())
        events[index].setAddress(address: modifiedEvent.getAddress())
        notify()
    }
    
}
