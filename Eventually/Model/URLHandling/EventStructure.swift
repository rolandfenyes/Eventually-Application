//
//  EventStructure.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 22..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import Foundation
import UIKit

struct EventStructure: Decodable {
    var id: Int?
    var name: String?
    var starttime: String?
    var endtime: String?
    var partlimit: Int?
    var description: String?
    //var photo: UIImage
    var visibility: String?
    //var location: ???
}
