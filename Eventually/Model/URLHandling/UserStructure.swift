//
//  UserStructure.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 13..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserStructure: Decodable {
    var id: Int?
    var email: String?
    var username: String?
    var birthdate: String?
    var pw: String?
}
