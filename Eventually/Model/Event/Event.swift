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
    private var participants: String
    private var subscribedParticipants: String
    private var shortDescription: String
    private var startDate: String
    private var endDate: String
    private var publicity: String
    private var image: UIImage?
    private var joined: Bool! = false
    private var creatorID: Int
    private var comments: [Comment]
    private var eventId: Int
    private var imageUrl: URL?
    
    //MARK: - Init
    init(eventName: String, eventLocation: CLLocationCoordinate2D, participants: String, subscribedParticipants: String, shortDescription: String, startDate: String, endDate: String, publicity: String, image: UIImage?, address: String, creatorID: Int, eventId: Int) {
        self.eventName = eventName
        self.eventLocation = eventLocation
        self.participants = participants
        self.subscribedParticipants = subscribedParticipants
        self.shortDescription = shortDescription
        self.startDate = startDate
        self.endDate = endDate
        self.publicity = publicity
        self.image = image
        self.address = address
        self.creatorID = creatorID
        self.eventId = eventId
        comments = []
    }
    
    init(eventName: String, eventLocation: String, participants: String, subscribedParticipants: String, shortDescription: String, startDate: String, endDate: String, publicity: String, image: UIImage?, address: String, creatorID: Int, eventId: Int) {
        self.eventName = eventName
        self.eventLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.participants = participants
        self.subscribedParticipants = subscribedParticipants
        self.shortDescription = shortDescription
        self.startDate = startDate
        self.endDate = endDate
        self.publicity = publicity
        self.image = image
        self.address = address
        self.creatorID = creatorID
        self.eventId = eventId
        comments = []
    }
    
    func setImageUrl(url: String) {
        self.imageUrl = URL(string: url)
        setImage(from: url)
    }
    
    func setJoined(status: Bool) {
        self.joined = status
        if (self.joined) {
            self.subscribedParticipants = String(Int(subscribedParticipants)! + 1)
        } else {
            self.subscribedParticipants = String(Int(subscribedParticipants)! - 1)
        }
    }
    
    func addComment(newComment: Comment) {
        comments.append(newComment)
    }
    
    //MARK: - Getters
    func getEventId() -> Int {
        return self.eventId
    }
    func getComments() -> [Comment] {
        return comments
    }
    func getName() -> String {
        return eventName
    }
    func getEventName() -> String {
        return self.eventName
    }
    func getEventLocation() -> CLLocationCoordinate2D {
        return self.eventLocation
    }
    func getParticipants() -> String {
        return self.participants
    }
    func getsubscribedParticipants() -> String {
        return self.subscribedParticipants
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
    func getCreatorID() -> Int {
        return self.creatorID
    }
    func isPublic() -> Bool {
        if (self.publicity == "PRIVATE" || self.publicity == "Privát") {
            return false
        }
        else {
            return true
        }
    }
    
    //MARK: - Setters
    func setCreatorId(id: Int) {
        self.creatorID = id
    }
    func setEventName(name: String) {
        self.eventName = name
    }
    func setEventLocation(location: CLLocationCoordinate2D) {
        self.eventLocation = location
    }
    func setParticipants(guests: String) {
        self.participants = guests
    }
    func setsubscribedParticipants(guests: String) {
        self.subscribedParticipants = guests
    }
    func setDescription(desc: String) {
        self.shortDescription = desc
    }
    func setStartDate(date: String) {
        self.startDate = date
    }
    func setEndDate(date: String) {
        self.endDate = date
    }
    func setPub(pub: String) {
        self.publicity = pub
    }
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    func setImage(image: UIImage) {
        self.image = image
    }
    func setAddress(address: String) {
        self.address = address
    }
    
} // end of the class
