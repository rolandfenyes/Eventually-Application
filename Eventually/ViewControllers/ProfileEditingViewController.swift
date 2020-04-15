//
//  ProfileEditingViewController.swift
//  Eventually
//
//  Created by Fényes Roland on 2020. 04. 15..
//  Copyright © 2020. Fényes Roland. All rights reserved.
//

import UIKit

class ProfileEditingViewController: UIViewController {

    //MARK: - Variables
    
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var profileDescription: UITextField!
    
    //MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Buttons
    
    @IBAction func changeProfilePicture(_ sender: UIButton) {
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        disappearScreen()
    }
    
    @IBAction func save(_ sender: UIButton) {
    }
    
    //MARK: - Service functions
    
    func disappearScreen() {
        dismiss(animated: true, completion: nil)
    }
    
} //end of the class
