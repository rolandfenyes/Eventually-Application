//
//  Profile.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 14..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import UIKit

class Profile : MyObserverForProfileEditing {
    
    //MARK: - Variables
    
     var name: String!
    private var nickname: String!
    private var password: String!
    private var profilePicture: UIImage?
    private var profileID: Int!
    private var emailAddress: String!
    private var birthDate: Date!
    
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
    
    private override init() {
        super.init()
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
    
    //MARK: - Change Profile
    
    func changeProfile(nickname: String, birthDate: Date, email: String, password: String, profilePicture: UIImage) {
        
        self.nickname = nickname
        self.birthDate = birthDate
        self.emailAddress = email
        self.password = password
        self.profilePicture = profilePicture
        
        notify()
    }
    
    //MARK: - Getters
    
    func getNickname() -> String {
        return self.nickname
    }
    func getBirthDate() -> Date {
        return self.birthDate
    }
    func getEmailAddress() -> String {
        return self.emailAddress
    }
    func getPassword() -> String {
        return self.password
    }
    func getProfilePicture() -> UIImage {
        return self.profilePicture ?? UIImage(systemName: "person.circle")!
    }
} //end of the class
