//
//  EventStructure.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 22..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct EventStructure: Decodable {
    var id: Int?
    var name: String?
    var description: String?
    var starttime: String?
    var endtime: String?
    var partlimit: Int?
    var part: Int?
    var status: String?
    var visibility: String?
}
