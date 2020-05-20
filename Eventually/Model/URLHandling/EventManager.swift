//
//  EventManager.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 22..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON
import Alamofire

class EventManager: MyObserverForEventList {
        
    //MARK: - APIError enum
    
    enum APIError: Error {
        case responseProblem
        case decodingProblem
        case encodingProblem
    }
    
    //MARK: - Variables
    
    let eventuallyURL = "https://api.eventually.site/"
    var organizerId: Int = 0
    var imageResponseUrl: URL? = nil
    
    func setOrganizerId(id: Int) {
        self.organizerId = id
    }
    
    func downloadEvents() {
        let urlString = "\(eventuallyURL)events"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        AF.request(urlString).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseJSON(events: json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - Parse Json and add to EventHandler
    
    func parseJSON(events: JSON) {
        let decoder = JSONDecoder()
        do {
            let decodedDatas = try decoder.decode([EventStructure].self, from: events.rawData())
            addEventsToEventHandler(eventList: decodedDatas, json: events)
        } catch {
            print(error)
        }
        
    }
    
    func addEventsToEventHandler(eventList: [EventStructure], json: JSON) {
        let eventHandler = EventHandler.shared()
        var partlimit = "0"
        var index = 0
        for event in eventList {
            if event.partlimit != nil {
                partlimit = String(event.partlimit!)
            }
            do {
                let location = json[index]["location"]
                let photo = json[index]["photo"]
                if location.count != 0 {
                    let lat = location["lat"].doubleValue
                    let lon = location["lon"].doubleValue
                    
                    let locationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    eventHandler.addEvent(event: Event(eventName: event.name!,
                                                         eventLocation: locationCoordinates,
                                                        participants: partlimit,
                                                        subscribedParticipants: String(event.part!),
                                                        shortDescription: event.description ?? "Description...",
                                                        startDate: event.starttime!,
                                                        endDate: event.endtime!,
                                                        publicity: event.visibility!,
                                                        image: UIImage(named: "cinema"),
                                                        address: "",
                                                        creatorID: event.id!,
                                                        eventId: event.id!))
                } else {
                    eventHandler.addEvent(event: Event(eventName: event.name!, eventLocation: "online", participants: partlimit, subscribedParticipants: String(event.part!), shortDescription: event.description ?? "Description...", startDate: event.starttime!, endDate: event.endtime!, publicity: event.visibility!, image: UIImage(named: "cinema"), address: "online", creatorID: event.id!, eventId: event.id!))
                }
                if let imageUrl = URL(string: photo["path"].stringValue) {
                    eventHandler.getEvents().last?.setImageUrl(url: photo["path"].stringValue)
                }
                let comments = json[index]["comments"].arrayValue
                for comment in comments {
                    eventHandler.addComment(newComment: Comment(userid: comment["userid"].intValue, eventid: comment["eventid"].intValue, body: comment["text"].stringValue), event: eventHandler.getEvents().last!)
                }
            }
            
            index += 1
        }
        for event in EventHandler.shared().getEvents() {
            getOrgainzerId(eventId: event.getCreatorID())
        }
    }
    
    func getOrgainzerId(eventId: Int) {
        let urlString = "\(eventuallyURL)events/\(eventId)/organizers"
        AF.request(urlString).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let decoder = JSONDecoder()
                do {
                    let decodedDatas = try decoder.decode(OrganizersStructure.self, from: json.rawData())
                    let index = EventHandler.shared().getEventIndexById(id: eventId)
                    EventHandler.shared().setCreatorIdForAnEvent(id: decodedDatas.userid, index: index)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    //MARK: - Send Event
    
    func register(_ codableEvent: CodableEvent, httpMethod: String, addToURL: String, completion: @escaping(Result<CodableEvent, APIError>) -> Void) {
        do {
            let jsonData = createJson(codableEvent: codableEvent)
            
            var resourceURL = URL(string: "\(eventuallyURL)events\(addToURL)")
            
            var urlRequest = URLRequest(url: resourceURL!)
            urlRequest.httpMethod = httpMethod
            
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
            uploadSession(urlRequest: urlRequest, completion: completion)
        } catch {
            completion(.failure(.decodingProblem))
        }
    }
    
    func uploadSession(urlRequest: URLRequest, completion: @escaping(Result<CodableEvent, APIError>) -> Void) {
        do {
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                    let jsonData = data else {
                        completion(.failure(.responseProblem))
                        return
                }
                
                do {
                    let messageData = try JSONDecoder().decode(CodableEvent.self, from: jsonData)
                    completion(.success(messageData))
                    self.imageResponseUrl = httpResponse.url
                    print(self.imageResponseUrl)
                } catch {
                    completion(.failure(.decodingProblem))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
    }
    
    //MARK: - Send Image
    
    func uploadImage(event: Event, completion: @escaping(Result<CodableEvent, APIError>) -> Void) {
        do {
            let data = event.getImage().pngData()?.base64EncodedString(options: .lineLength64Characters)
            var imageDict: [String : AnyObject] = [:]
            imageDict["file"] = data as AnyObject?
            
            let resourceURL = URL(string: "\(eventuallyURL)uploadFile")
            var urlRequest = URLRequest(url: resourceURL!)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = jsonToData2(dict: imageDict)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            uploadSession(urlRequest: urlRequest, completion: completion)
        } catch {
            completion(.failure(.decodingProblem))
        }
        
        
    }
        
    
    //MARK: - Send Comment
    
    func sendComment(_ message: Comment, httpMethod: String, completion: @escaping(Result<CodableEvent, APIError>) -> Void) {
        
        let jsonData = createCommentJson(message: message)
        
        let resourceURL = URL(string: "\(eventuallyURL)comments")
        var urlRequest = URLRequest(url: resourceURL!)
        urlRequest.httpMethod = httpMethod
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        uploadSession(urlRequest: urlRequest, completion: completion)
    }
    
    //MARK: - Create Jsons
    
    func createCommentJson(message: Comment) -> Data {
        var commentsDict: [String : AnyObject] = [:]
        var commentDict: [String : AnyObject] = [:]
        commentDict["text"] = message.body as AnyObject
        commentDict["status"] = "ACTIVE" as AnyObject
        commentsDict["comment"] = commentDict as AnyObject
        commentsDict["eventid"] = message.eventid as AnyObject
        commentsDict["userid"] = message.userid as AnyObject
        
        return jsonToData(dict: commentsDict)
    }
    
    func createJson(codableEvent: CodableEvent) -> Data {
        
        let index = EventHandler.shared().getEventIndexById(id: codableEvent.id)
        uploadImage(event: EventHandler.shared().getEvents()[index], completion: { result in
            switch result {
            case .success(let codableEvent):
                print(codableEvent.name)
            case .failure(let error):
                print(error)
            }
        })
        
        var visibility: String
        if codableEvent.visibility == "Publikus" {
            visibility = "PUBLIC"
        } else {
            visibility = "PRIVATE"
        }
        
        var locationDict: [String : Double] = [:]
        locationDict["lon"] = codableEvent.lon
        locationDict["lat"] = codableEvent.lat
        
        var eventDict: [String : AnyObject] = [:]
        eventDict["name"] = codableEvent.name as AnyObject
        eventDict["description"] = codableEvent.description as AnyObject
        eventDict["starttime"] = codableEvent.starttime as AnyObject
        eventDict["endtime"] = codableEvent.endtime as AnyObject
        eventDict["partlimit"] = codableEvent.partlimit as AnyObject
        eventDict["visibility"] = visibility as AnyObject
        
        var photoDict: [String : AnyObject] = [:]
        photoDict["path"] = self.imageResponseUrl as AnyObject
        
        var dict: [String : AnyObject] = [:]
        dict["event"] = eventDict  as AnyObject
        dict["location"] = locationDict  as AnyObject
        dict["photo"] = photoDict as AnyObject
        dict["userid"] = Profile.shared().getID() as AnyObject
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let fileManager = FileManager.default
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let jsonUrl = url.appendingPathComponent("event.json")
            print(jsonUrl)
            try jsonData.write(to: jsonUrl)

            return jsonData
        } catch {
            
        }
        return Data()
    }
    
    //MARK: - Json to Data
    
    func jsonToData(dict: Dictionary<String, Any>) -> Data {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let fileManager = FileManager.default
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let jsonUrl = url.appendingPathComponent("event.json")
            print(jsonUrl)
            try jsonData.write(to: jsonUrl)

            return jsonData
        } catch {
            
        }
        return Data()
    }
    
    func jsonToData2(dict: Dictionary<String, Any>) -> Data {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let fileManager = FileManager.default
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let jsonUrl = url.appendingPathComponent("image.json")
            print(jsonUrl)
            try jsonData.write(to: jsonUrl)

            return jsonData
        } catch {
            
        }
        return Data()
    }
    
    //MARK: - String to Date
    
    func stringToDate(string: String) -> Date {
        let formatter = DateFormatter()
        let date = formatter.date(from: string)!
        return date
    }
    
}
