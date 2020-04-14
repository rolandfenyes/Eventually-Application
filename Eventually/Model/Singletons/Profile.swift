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
    
    private var name: String!
    private var nickname: String!
    private var password: String!
    private var profilePicture: UIImage?
    private let profileID: Int!
    private var emailAddress: String!
    
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
        self.profileID = 0
    }
    
    //MARK: - Login Session
    
}
