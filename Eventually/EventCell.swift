//
//  EventCell.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 01..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    private var event: Event? = nil
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDurationLabel: UILabel!
    @IBOutlet weak var joinedTicket: UIImageView!
    
    func setEvent(event: Event) {
        self.event = event
        eventImageView.image = event.getImage()
        eventTitleLabel.text = event.getName()
        eventDurationLabel.text = event.getStartDate()
        if (!event.getIsJoined()) {
            joinedTicket.isHidden = true
        }
        else {
            joinedTicket.isHidden = false
        }
    }

} //end of the class
