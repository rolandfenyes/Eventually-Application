//
//  MessageCell.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 05. 06..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var personImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 10
        personImage.image = Profile.shared().getProfilePicture()
        setPersonImageRound()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPersonImageRound() {
        personImage.layer.borderWidth = 0
        personImage.layer.masksToBounds = false
        personImage.layer.borderColor = UIColor.black.cgColor
        personImage.layer.cornerRadius = personImage.frame.height/2
        personImage.clipsToBounds = true
    }
    
}
