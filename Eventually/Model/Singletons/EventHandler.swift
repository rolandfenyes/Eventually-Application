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
    
    func sendToBackEnd(event: Event, httpMethod: String) {
        let postRequest = EventManager()
        let codableEvent = CodableEvent(name: event.getName(), description: event.getDescription(), starttime: event.getStartDate(), endtime: event.getEndDate(), partlimit: event.getParticipants(), part: event.getsubscribedParticipants(), visibility: event.getPub(), location: event.getEventLocation(), id: event.getEventId(), comments: event.getComments())
        
        var addToURL = ""
        if httpMethod == "PUT" {
            addToURL = "/\(event.getEventId())"
        }
        
        postRequest.register(codableEvent, httpMethod: httpMethod, addToURL: addToURL, completion: { result in
            switch result {
            case .success(let codableEvent):
                print(codableEvent.name)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func sendComment(message: Comment) {
        let postRequest = EventManager()
        postRequest.sendComment(message, httpMethod: "POST", completion: {result in
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    func clear() {
        events.removeAll()
    }
    
    func setJoinForAnEvent(status: Bool, index: Int) {
        events[index].setJoined(status: status)
        notify()
    }
    func setCreatorIdForAnEvent(id: Int, index: Int) {
        events[index].setCreatorId(id: id)
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
    
    func getEventIndexById(id: Int) -> Int {
        var eventToReturn: Event = events.first!
        for event in events {
            if event.getCreatorID() == id {
                eventToReturn = event
            }
        }
        return getExactEventIndex(event: eventToReturn)
    }
    
    func getExactEvent(event: Event) -> Event {
        let index = getExactEventIndex(event: event)
        return self.events[index]
    }
    
    func getMyEvents() -> [Event] {
        let creatorId = Profile.shared().getID()
        var myEvents: [Event] = []
        
        for eventInList in self.events {
            if eventInList.getCreatorID() == creatorId {
                myEvents.append(eventInList)
            }
        }
        return myEvents
    }
    
    func getSubscribedEvents() -> [Event] {
        var myEvents: [Event] = []
        
        for event in self.events {
            if event.getIsJoined() {
                myEvents.append(event)
            }
        }
        return myEvents
    }
    
    func addComment(newComment: Comment, event: Event) {
        events[getExactEventIndex(event: event)].addComment(newComment: newComment)
        sendComment(message: newComment)
        notify()
    }
    
    func editEvent(oldEvent: Event, modifiedEvent: Event) {
        let index = getExactEventIndex(event: oldEvent)
        events[index].setEventName(name: modifiedEvent.getEventName())
        events[index].setEventLocation(location: modifiedEvent.getEventLocation())
        events[index].setParticipants(guests: modifiedEvent.getParticipants())
        events[index].setDescription(desc: modifiedEvent.getDescription())
        events[index].setStartDate(date: modifiedEvent.getStartDate())
        events[index].setEndDate(date: modifiedEvent.getEndDate())
        events[index].setPub(pub: modifiedEvent.getPub())
        events[index].setImage(image: modifiedEvent.getImage())
        events[index].setAddress(address: modifiedEvent.getAddress())
        notify()
    }
    
}
