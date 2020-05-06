//
//  EventCell.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 06..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEvent(event: Event) {
        self.event = event
        eventImageView.image = event.getImage()
        eventTitleLabel.text = event.getName()
        eventDurationLabel.text = event.getStartDate()
        setParticipants()
        setPrivacy()
        setSubscription()
    }
    
    func setParticipants() {
        let part = (((event?.getsubscribedParticipants())!)+"/"+(event?.getParticipants())!)
        participants.text = part
    }
    
    func setPrivacy() {
        if (self.event!.isPublic()) {
            privateIcon.isHidden = true
        }
        else {
            privateIcon.isHidden = false
        }
    }
    
    func setSubscription() {
        if (!self.event!.getIsJoined()) {
            joinedTicket.isHidden = true
        }
        else {
            joinedTicket.isHidden = false
        }
    }
    
}
