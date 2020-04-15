//
//  SettingsViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 14..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, PObserver{
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    private let profile = Profile.shared()

    override func viewDidLoad() {
        super.viewDidLoad()

        Profile.shared().attach(observer: self)
        
        loadProfileDetails()
    }

    func loadProfileDetails() {
        self.profileName.text = self.profile.getNickname()
        self.profilePicture.image = self.profile.getProfilePicture()
    }
    
    func update() {
        loadProfileDetails()
    }


}
