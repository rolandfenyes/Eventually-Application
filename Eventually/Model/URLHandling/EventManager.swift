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
                                                        creatorID: event.organizer?.id ?? 0))
                } else {
                    eventHandler.addEvent(event: Event(eventName: event.name!, eventLocation: "online", participants: partlimit, subscribedParticipants: "0", shortDescription: event.description ?? "Description...", startDate: event.starttime!, endDate: event.endtime!, publicity: event.visibility!, image: UIImage(named: "cinema"), address: "online", creatorID: 1))
                }
            } catch {
                print(error)
            }
            
            index += 1
        }
    }
    
    func saveEvent(_ event: CodableEvent, completion: @escaping(Result<CodableEvent, APIError>) -> Void) {
  
        guard let resourceURL = URL(string: eventuallyURL) else { return }
        
        let body: [String: String] = ["name": event.name, "description": event.description, "starttime": event.starttime, "endtime": event.endtime, "partlimit": String(event.partlimit), "part": String(event.part), "visibility": event.visibility]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
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
    
}
