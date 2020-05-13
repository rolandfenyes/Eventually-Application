//
//  UserManager.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 13..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class UserManager {
    
    enum APIError: Error {
        case responseProblem
        case decodingProblem
        case encodingProblem
    }
    
    let eventuallyURL = "https://api.eventually.site/"
    
    func downloadUsers() {
        let urlString = "\(eventuallyURL)users"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        AF.request(urlString).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseJSON(json: json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func parseJSON(json: JSON) {
        let decoder = JSONDecoder()
        do {
            let decodedDatas = try decoder.decode([UserStructure].self, from: json.rawData())
            for user in decodedDatas {
                UsersList.shared().addUser(user: user)
            }
        } catch {
            print(error)
        }
    }
    
    func auth(email: String, password: String) -> Bool {
        let userList = UsersList.shared().getUsers()
        for user in userList {
            if (user.email == email && user.pw == password) {
                Profile.shared().changeProfile(id: user.id!, nickname: user.username!, birthDate: stringToDate(string: user.birthdate!), email: user.email!, password: user.pw!, profilePicture: nil)
                return true
            }
        }
        return false
    }
    
    func stringToDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from:string)!
        return date
    }
    
    func register(_ userToRegister: UserStructure, httpMethod: String, addToURL: String, completion: @escaping(Result<UserStructure, APIError>) -> Void) {
        do {
            let jsonData = createJson(user: userToRegister)
            
            let resourceURL = URL(string: "\(eventuallyURL)users\(addToURL)")
            
            var urlRequest = URLRequest(url: resourceURL!)
            urlRequest.httpMethod = httpMethod
            
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                    let jsonData = data else {
                        completion(.failure(.responseProblem))
                        return
                }
                
                do {
                    let messageData = try JSONDecoder().decode(UserStructure.self, from: jsonData)
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
    
    func createJson(user: UserStructure) -> Data {
        var userDict: [String: AnyObject] = [:]
        var userdetailsDict: [String: AnyObject] = [:]
        userdetailsDict["username"] = user.username as AnyObject
        userdetailsDict["birthdate"] = user.birthdate as AnyObject
        userdetailsDict["email"] = user.email as AnyObject
        userdetailsDict["pw"] = user.pw as AnyObject
        var userPhotoDict: [String: AnyObject] = [:]
        userDict["user"] = userdetailsDict as AnyObject
        userDict["photo"] = userPhotoDict as AnyObject
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted)
            let fileManager = FileManager.default
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let jsonUrl = url.appendingPathComponent("user.json")
            print(jsonUrl)
            try jsonData.write(to: jsonUrl)

            return jsonData
        } catch {
            
        }
        return Data()
    }
    
}
