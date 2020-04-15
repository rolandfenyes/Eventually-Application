//
//  Profile.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 14..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import UIKit

class Profile {
    
    //MARK: - Variables
    
    var name: String!
    var nickname: String!
    var password: String!
    var profilePicture: UIImage?
    let profileID: Int!
    var emailAddress: String!
    var birthDate: Date!
    
    private let myEventList: [Event] = []
    private let subscribedEventList: [Event] = []
    
    //MARK: - Singleton
    
    class func shared() -> Profile {
        return profile
    }
    
    private static var profile: Profile = {
        let profile = Profile()
        return profile
    }()
    
    private init() {
        self.nickname = "admin"
        self.password = "password"
        self.profileID = 0
        self.emailAddress = "admin@admin.com"
        self.birthDate = setBirthDate()
    }
    
    private func setBirthDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.date(from: "2000/01/22")!
    }
    
    //MARK: - Login Session
    
} //end of the class
