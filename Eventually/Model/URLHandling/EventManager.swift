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
        
    enum APIError: Error {
        case responseProblem
        case decodingProblem
        case encodingProblem
    }
    
    let eventuallyURL = "https://api.eventually.site/"
    
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
        let jsonList = json.array
        for event in eventList {
            if event.partlimit != nil {
                partlimit = String(event.partlimit!)
            }
            do {
                print(jsonList![index])
                let location = json[index]["location"]
                let organizer = json[index]["organizer"]
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
                                                        //TODO
                                                        image: UIImage(named: "cinema"),
                                                        address: "",
                                                        creatorID: organizer["id"].intValue))
                } else {
                    eventHandler.addEvent(event: Event(eventName: event.name!, eventLocation: "online", participants: partlimit, subscribedParticipants: String(event.part!), shortDescription: event.description ?? "Description...", startDate: event.starttime!, endDate: event.endtime!, publicity: event.visibility!, image: UIImage(named: "cinema"), address: "online", creatorID: organizer["id"].intValue))
                }
            }
            
            index += 1
        }
    }
    
    func saveEvent(_ event: CodableEvent, completion: @escaping(Result<CodableEvent, APIError>) -> Void) {
  
        guard let resourceURL = URL(string: eventuallyURL) else { return }
        
        let finalBody = createJson(codableEvent: event)
        
        var urlRequest = URLRequest(url: resourceURL)
        
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = finalBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, respons, error) in
            
            guard let data = data else { return }
            
            let finalData =  try! JSONDecoder().decode(CodableEvent.self, from: data)
            
            print(finalData)
        }.resume()
        
    }
    
    func register(_ codableEvent: CodableEvent, completion: @escaping(Result<CodableEvent, APIError>) -> Void) {
        do {
            let jsonData = createJson(codableEvent: codableEvent)
            
            let resourceURL = URL(string: "\(eventuallyURL)events")
            var urlRequest = URLRequest(url: resourceURL!)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                    let jsonData = data else {
                        completion(.failure(.responseProblem))
                        print("register")
                        return
                }
                
                do {
                    let messageData = try JSONDecoder().decode(CodableEvent.self, from: jsonData)
                    completion(.success(messageData))
                } catch {
                    completion(.failure(.decodingProblem))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
    }
    
    func createJson(codableEvent: CodableEvent) -> Data {
        
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
        
        var dict: [String : AnyObject] = [:]
        dict["event"] = eventDict  as AnyObject
        dict["location"] = locationDict  as AnyObject
        dict["photo"] = photoDict as AnyObject
        dict["userid"] = 1 as AnyObject //Profile.shared().getID() as AnyObject
        
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
    
    func stringToDate(string: String) -> Date {
        let formatter = DateFormatter()
        let date = formatter.date(from: string)!
        return date
    }
    
}
