//
//  OrganizersStructure.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 13..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation

struct OrganizersStructure: Codable {
    var userid: Int
    
    init(userid: Int) {
        self.userid = userid
    }
}
