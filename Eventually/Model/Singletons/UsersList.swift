//
//  UsersList.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 13..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation

class UsersList {
    
    private var users: [UserStructure]
    
    class func shared() -> UsersList {
        return usersList
    }
    private static var usersList: UsersList = {
        let usersList = UsersList()
        return usersList
    }()
    
    init() {
        self.users = []
    }
    
    func addUser(user: UserStructure) {
        users.append(user)
        print(user)
    }
    
    func getUsers() -> [UserStructure] {
        return self.users
    }
}
