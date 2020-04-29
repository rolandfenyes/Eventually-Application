//
//  EventManager.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 22..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import MapKit

class EventManager {
    
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
        //1. Create URL
        
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(events: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(events: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedDatas = try decoder.decode([EventStructure].self, from: events)
            addEventsToEventHandler(eventList: decodedDatas)
        } catch {
            print(error)
        }
        
    }
    
    func addEventsToEventHandler(eventList: [EventStructure]) {
        let eventHandler = EventHandler.shared()
        var partlimit = "0"
        for event in eventList {
            if event.partlimit != nil {
                partlimit = String(event.partlimit!)
            }
            eventHandler.addEvent(event: Event(eventName: event.name!,
                                               //TODO
                                               eventLocation: CLLocationCoordinate2D(latitude: 47.49810821206292, longitude: 19.066526661626995),
                                               participants: partlimit,
                                               subscribedParticipants: "0",
                                               shortDescription: event.description ?? "Description...",
                                               startDate: event.starttime!,
                                               endDate: event.endtime!,
                                               publicity: event.visibility!,
                                               //TODO
                                               image: UIImage(named: "cinema"),
                                               address: "Füge udvar Budapest",
                                               creatorID: 0))
        }
    }
    
    func saveEvent(_ event: CodableEvent, completion: @escaping(Result<CodableEvent, APIError>) -> Void) {
        
        do {
            guard let resourceURL = URL(string: eventuallyURL) else {fatalError()}
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(event)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
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
    
}
