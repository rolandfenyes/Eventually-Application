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
    @IBOutlet weak var privateIcon: UIImageView!
    @IBOutlet weak var participants: UILabel!
    
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

} //end of the class
